'use strict';

define(['subtitles.player.model', 'backbone'], function (SubtitlesPlayerModel, Backbone) {

    describe('Subtitles player model', function() {
        beforeEach(function() {
            var original = [];
            var translation = [];
            for (var i = 0; i < 10; i++) {
                original.push({ text: 'test', ts: i*10000 });
                translation.push('examen');
            }

            this.dataProvider = {
                getSegments: function (id, toLanguage, callback) {
                    callback({
                        original: original,
                        translation: translation
                    });
                }
            };

            var MusicPlayer = Backbone.Model.extend({
                play: function () {},
                pause: function () {},
                seek: function () {},
                getTrackPosition: function () {
                    return 0;
                }
            });
            this.musicPlayer = new MusicPlayer();

            this.model = new SubtitlesPlayerModel({
                dataProvider: this.dataProvider,
                musicPlayer: this.musicPlayer,
                toLanguage: 'en',
                fromLanguage: 'fr',
                enableLogging: false
            });
            this.musicPlayer.set({
                currentSong: {
                    name: 'original song'
                }
            })
        });

        describe('On change of current song', function() {
            it('i is set to 0', function() {
                this.model.set({
                    i: 1
                });
                expect(this.model.get('i')).toBe(1);
                this.musicPlayer.set({
                    currentSong: {
                        name: 'new song!'
                    }
                });
                expect(this.model.get('i')).toBe(0);
            });
            it('clear timer is called', function() {
                spyOn(this.model, 'clearTimer');
                this.musicPlayer.set({
                    currentSong: {
                        name: 'new song!'
                    }
                });
                expect(this.model.clearTimer).toHaveBeenCalled();
            });
            it('new subtitles fetched', function() {
                spyOn(this.model, 'getSubtitles');
                this.musicPlayer.set({
                    currentSong: {
                        name: 'new song!'
                    }
                });
                expect(this.model.getSubtitles).toHaveBeenCalled();
            });
        });
        describe('On play', function() {
            it('call musicPlayer play', function() {
                spyOn(this.musicPlayer, 'play');
                this.model.play();
                expect(this.musicPlayer.play).toHaveBeenCalled();
            });
        });
        describe('On pause', function() {
            it('call musicPlayer pause', function() {
                spyOn(this.musicPlayer, 'pause');
                this.model.pause();
                expect(this.musicPlayer.pause).toHaveBeenCalled();
            });
            it('clear timer for next check', function() {
                spyOn(this.model, 'clearTimer');
                this.model.pause();
                expect(this.model.clearTimer).toHaveBeenCalled();
            });
        });
        describe('On prev', function() {
            it('call musicPlayer seek with correct timestamp', function() {
                this.model.set({
                    i: 2
                });
                spyOn(this.musicPlayer, 'seek');
                this.model.prev();
                var nextTs = this.model.get('subtitles').original[1].ts;
                expect(this.musicPlayer.seek).toHaveBeenCalledWith(nextTs);
            });
            it('clear timer for next check', function() {
                spyOn(this.model, 'clearTimer');
                this.model.prev();
                expect(this.model.clearTimer).toHaveBeenCalled();
            });
            it('i doesnt go below 0', function() {
                this.model.prev();
                expect(this.model.get('i')).toBe(0);
            });
            it('No error when no subtitles', function() {
                this.model.set({
                    subtitles: {}
                });
                this.model.prev();
            });
            it('i is one less if within a second', function() {
                this.model.set({
                    subtitles: {
                        original: [
                            { text: 'test', ts: 0 },
                            { text: 'test', ts: 5000 }
                        ]
                    },
                    i: 1
                });

                this.musicPlayer.getTrackPosition = function() {
                    return 5900;
                };

                this.model.prev();
                expect(this.model.get('i')).toBe(0);
            });
            it('i is the same if past a second', function() {
                this.model.set({
                    subtitles: {
                        original: [
                            { text: 'test', ts: 0 },
                            { text: 'test', ts: 5000 }
                        ]
                    },
                    i: 1
                });

                this.musicPlayer.getTrackPosition = function() {
                    return 6100;
                };

                this.model.prev();
                expect(this.model.get('i')).toBe(1);
            });
        });
        describe('On next', function() {
            it('call musicPlayer seek', function() {
                spyOn(this.musicPlayer, 'seek');
                this.model.next();
                var nextTs = this.model.get('subtitles').original[1].ts;
                expect(this.musicPlayer.seek).toHaveBeenCalledWith(nextTs);
            });
            it('clear timer for next check', function() {
                spyOn(this.model, 'clearTimer');
                this.model.next();
                expect(this.model.clearTimer).toHaveBeenCalled();
            });
            it('i is one more', function() {
                this.model.next();
                expect(this.model.get('i')).toBe(1);
            });
            it('i doesnt go past subtitles length - 1', function() {
                var maxLength = this.model.get('subtitles').original.length - 1;
                this.model.set({
                    i: maxLength
                });
                this.model.next();
                expect(this.model.get('i')).toBe(maxLength);
            });
        });
        describe('On start', function() {
            it('clears previous timer', function() {
                spyOn(this.model, 'clearTimer');
                this.model.start();
                expect(this.model.clearTimer).toHaveBeenCalled();
            });
            it('timer is not set if there is not a next index', function() {
                var maxLength = this.model.get('subtitles').original.length - 1;
                this.model.set({
                    i: maxLength
                });
                this.model.start();
                expect(this.model.timer).toBe(null);
            });
            it('timer is set for time diff between next and current time', function() {
                var nextTs = this.model.get('subtitles').original[1].ts;
                this.musicPlayer.getTrackPosition = function() {
                    return 50;
                };
                spyOn(this.model, 'setTimer');
                this.model.start();
                expect(this.model.setTimer.mostRecentCall.args[1]).toEqual(nextTs-50);
            });
            it('when timer finishes, it sets timer for next segment and so on', function() {
                this.model.set({
                    subtitles: {
                        original: [
                            { text: 'test', ts: 0 },
                            { text: 'test', ts: 10 },
                            { text: 'test', ts: 20 },
                            { text: 'test', ts: 30 }
                        ]
                    }
                });

                this.model.start();
                waitsFor(function() {
                    return this.model.get('i') === 3;
                }, "The index should be incremented", 1000);
            });
        });
    });

});