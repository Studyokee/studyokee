'use strict';

define(['subtitles.player.model', 'subtitles.player.view', 'backbone'], function (SubtitlesPlayerModel, SubtitlesPlayerView, Backbone) {

    describe('Subtitles player', function() {
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
            });
        });

        describe('Model', function() {
            describe('On change of playing', function() {
                it('if playing is true, start', function() {
                    spyOn(this.model, 'start');
                    this.musicPlayer.set({
                        playing: true
                    });
                    expect(this.model.start).toHaveBeenCalled();
                });
                it('if playing is false, dont start', function() {
                    this.musicPlayer.set({
                        playing: true
                    });
                    spyOn(this.model, 'start');
                    this.musicPlayer.set({
                        playing: false
                    });
                    expect(this.model.start).not.toHaveBeenCalled();
                });
            });
            describe('On change of current song', function() {
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
            describe('On getSubtitles', function() {
                it('null song data results in empty subtitles object and doesnt call dataProvider', function() {
                    spyOn(this.dataProvider, 'getSegments');
                    this.model.getSubtitles(null);
                    expect(this.model.get('subtitles').original).toBe(undefined);
                    expect(this.dataProvider.getSegments).not.toHaveBeenCalled();
                });
                it('getSubtitles sets isLoading', function() {
                    this.dataProvider.getSegments = function (){};
                    this.model.getSubtitles({});
                    expect(this.model.get('isLoading')).toBe(true);
                });
                it('getSubtitles sets playing to false', function() {
                    this.model.getSubtitles({});
                    expect(this.model.get('playing')).toBe(false);
                });
                it('successful dataProvider get results in subtitles set, i as 0, and loading to false', function() {
                    this.model.set({
                        i: 1
                    });

                    var expectedString = 'success!';
                    this.dataProvider.getSegments = function (id, toLanguage, callback) {
                        callback({
                            original: [{ text: expectedString, ts: 0 }, { text: 'success2!', ts: 10 }],
                            translation: []
                        });
                    };

                    this.model.getSubtitles({});

                    expect(this.model.get('isLoading')).toBe(false);
                    expect(this.model.get('i')).toBe(0);
                    expect(this.model.get('subtitles').original[0].text).toBe(expectedString);
                });
                it('only runs the callback if it is for the most recent request', function() {
                    
                    var firstCallback = null;
                    this.dataProvider.getSegments = function (id, toLanguage, callback) {
                        firstCallback = callback;
                    };
                    this.model.getSubtitles({
                        key: '1'
                    });
                    var expectedString = 'success!';
                    this.dataProvider.getSegments = function (id, toLanguage, callback) {
                        callback({
                            original: [{ text: expectedString, ts: 0 }]
                        });
                    };
                    this.model.getSubtitles({
                        key: '2'
                    });
                    firstCallback({
                        original: [{ text: 'false string', ts: 0 }]
                    });

                    expect(this.model.get('subtitles').original[0].text).toBe(expectedString);
                });
            });
            describe('On play', function() {
                it('call musicPlayer play', function() {
                    spyOn(this.musicPlayer, 'play');
                    this.model.play();
                    expect(this.musicPlayer.play).toHaveBeenCalled();
                });
                it('playing is set to true', function() {
                    this.model.play();
                    expect(this.model.get('playing')).toBe(true);
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
                it('playing is set to false', function() {
                    this.model.pause();
                    expect(this.model.get('playing')).toBe(false);
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
                    }, 'The index should be incremented', 1000);
                });
            });
        });

        describe('View', function() {
            beforeEach(function() {
                this.view = new SubtitlesPlayerView({
                    model: this.model
                });
                this.el = this.view.render().el;
            });

            describe('On isLoading change', function() {
                it('shows spinner when true', function() {
                    this.model.set({
                        isLoading: true
                    });
                    expect($(this.el).find('.spinner').length).toBe(1);
                });
                it('hides spinner when false', function() {
                    this.model.set({
                        isLoading: false
                    });
                    expect($(this.el).find('.spinner').length).toBe(0);
                });
            });

            describe('On currentSong change', function() {
                it('current song is visible when not null', function() {
                    this.model.set({
                        currentSong: {
                            name: 'test'
                        }
                    });
                    var songContainer = $(this.el).find('.song');
                    expect(songContainer.css('visibility')).toBe('visible');
                });
                it('current song is hidden when null', function() {
                    this.model.set({
                        currentSong: null
                    });
                    var songContainer = $(this.el).find('.song');
                    expect(songContainer.css('visibility')).toBe('hidden');
                });
            });
        });
    });

});