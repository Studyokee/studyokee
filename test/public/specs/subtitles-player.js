'use strict';

define(['subtitles.player.model', 'subtitles.player.view', 'backbone'], function (SubtitlesPlayerModel, SubtitlesPlayerView, Backbone) {

    var helpers = {
        createTestModel: function () {
            var original = [];
            var translation = [];
            for (var i = 0; i < 10; i++) {
                original.push({ text: 'test', ts: i*10000 });
                translation.push('examen');
            }

            var dataProvider = {
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
                setSong: function () {}
            });
            var musicPlayer = new MusicPlayer();

            var model = new SubtitlesPlayerModel({
                musicPlayer: musicPlayer,
                dataProvider: dataProvider,
                currentSong: {
                    _id: '0',
                    name: 'Test Song Name',
                    artist: 'Test Artist',
                    icon: 'http://rdio-a.cdn3.rdio.com/album/1/6/e/000000000002ce61/2/square-200.jpg'
                }
            });
            model.dataProvider = dataProvider;
            return model;
        },
        createTestView: function () {
            var view = new SubtitlesPlayerView({
                model: this.createTestModel()
            });
            return view;
        }
    };

    describe('SubtitlesPlayer', function() {
        describe('Model', function() {
            beforeEach(function() {
                this.model = helpers.createTestModel();
                this.dataProvider = this.model.get('dataProvider');
                this.musicPlayer = this.model.get('musicPlayer');
            });

            describe('On change of MusicPlayer syncTo', function() {
                it('if playing is true, start with correct ts', function() {
                    this.model.set({
                        playing: true
                    });
                    spyOn(this.model, 'setPosition');
                    this.musicPlayer.set({
                        syncTo: 10
                    });
                    expect(this.model.setPosition).toHaveBeenCalledWith(10);
                });
                it('if playing is false, dont start', function() {
                    this.model.set({
                        playing: false
                    });
                    spyOn(this.model, 'setPosition');
                    this.musicPlayer.set({
                        syncTo: 10
                    });
                    expect(this.model.setPosition).not.toHaveBeenCalled();
                });
            });
            describe('On change of current song', function() {
                it('pause is called', function() {
                    spyOn(this.model, 'pause');
                    this.model.set({
                        currentSong: {
                            name: 'new song!'
                        }
                    });
                    expect(this.model.pause).toHaveBeenCalled();
                });
                it('new subtitles fetched', function() {
                    spyOn(this.model, 'getSubtitles');
                    this.model.set({
                        currentSong: {
                            name: 'new song!'
                        }
                    });
                    expect(this.model.getSubtitles).toHaveBeenCalled();
                });
                it('null song data results in empty subtitles object and doesnt call dataProvider', function() {
                    spyOn(this.dataProvider, 'getSegments');
                    this.model.set({
                        currentSong: null
                    });
                    expect(this.model.get('subtitles').original).toBe(undefined);
                    expect(this.dataProvider.getSegments).not.toHaveBeenCalled();
                });
            });
            describe('On getSubtitles', function() {
                it('getSubtitles sets isLoading', function() {
                    this.dataProvider.getSegments = function () {};
                    this.model.getSubtitles();
                    expect(this.model.get('isLoading')).toBe(true);
                });
                it('successful dataProvider get results in isLoading to false', function() {
                    this.model.set({
                        isLoading: true
                    });
                    this.model.getSubtitles();
                    expect(this.model.get('isLoading')).toBe(false);
                });
                it('successful dataProvider get results in i as 0', function() {
                    this.model.set({
                        i: 1
                    });
                    this.model.getSubtitles();
                    expect(this.model.get('i')).toBe(0);
                });
                it('successful dataProvider get results in subtitles set, i as 0, playing to false, and loading to false', function() {
                    var expectedString = 'Success!';
                    this.dataProvider.getSegments = function (id, toLanguage, callback) {
                        callback({
                            original: [{ text: expectedString, ts: 0 }]
                        });
                    };
                    this.model.getSubtitles({});
                    expect(this.model.get('subtitles').original[0].text).toBe(expectedString);
                });
                it('only runs the callback if it is for the most recent request', function() {
                    
                    var firstCallback = null;
                    this.dataProvider.getSegments = function (id, toLanguage, callback) {
                        firstCallback = callback;
                    };
                    this.model.set({
                        currentSong: {
                            _id: '1'
                        }
                    });
                    var expectedString = 'success!';
                    this.dataProvider.getSegments = function (id, toLanguage, callback) {
                        callback({
                            original: [{ text: expectedString, ts: 0 }]
                        });
                    };
                    this.model.set({
                        currentSong: {
                            _id: '2'
                        }
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
                it('no error when no subtitles', function() {
                    this.model.set({
                        subtitles: {}
                    });
                    this.model.prev();
                });
                it('i is one less if within a second', function() {
                    this.model.set({
                        i: 2,
                        playing: true
                    });

                    this.model.prev();
                    this.model.prev();
                    this.model.prev();
                    expect(this.model.get('i')).toBe(0);
                });
                it('i is one less if playing is false', function() {
                    var time;
                    runs(function() {
                        this.model.set({
                            i: 1,
                            playing: false
                        });

                        this.model.prev();
                        time = new Date().getTime();
                    });

                    waitsFor(function() {
                        var currentTime = new Date().getTime();
                        return (currentTime - time) > (this.model.get('prevPause') + 10);
                    }, 'wait should have worked', this.model.get('prevPause') * 2);

                    runs(function() {
                        this.model.prev();
                        expect(this.model.get('i')).toBe(0);
                    });
                });
                it('i is the same if past a second', function() {
                    var time;
                    runs(function() {
                        this.model.set({
                            i: 1,
                            playing: true
                        });

                        this.model.prev();
                        time = new Date().getTime();
                    });

                    waitsFor(function() {
                        var currentTime = new Date().getTime();
                        return (currentTime - time) > (this.model.get('prevPause') + 10);
                    }, 'wait should have worked', this.model.get('prevPause') * 2);

                    runs(function() {
                        this.model.prev();
                        expect(this.model.get('i')).toBe(1);
                    });
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
            describe('On setPosition', function() {
                it('clears previous timer', function() {
                    spyOn(this.model, 'clearTimer');
                    this.model.setPosition(0);
                    expect(this.model.clearTimer).toHaveBeenCalled();
                });
                it('no optimistic timer set if invalid ts', function() {
                    spyOn(this.model, 'doOmptimisticTimer');
                    this.model.setPosition(null);
                    expect(this.model.doOmptimisticTimer).not.toHaveBeenCalled();
                });
                it('sets i based on ts', function() {
                    this.model.set({
                        i: 9
                    });
                    this.model.setPosition(15000);
                    expect(this.model.get('i')).toBe(1);
                });
            });
            describe('getPosition', function() {
                beforeEach(function() {
                    var original = [];
                    for (var i = 0; i < 10; i++) {
                        original.push({ text: 'test', ts: i*10 });
                    }
                    this.model.set({
                        subtitles: {
                            original: original
                        }
                    });
                });
                it('if no ts, returns null', function() {
                    expect(this.model.getPosition()).toBe(null);
                });
                it('if no subtitles, returns null', function() {
                    this.model.set({
                        subtitles: {}
                    });
                    expect(this.model.getPosition(0)).toBe(null);
                });
                it('if no original subtitles, returns null', function() {
                    this.model.set({
                        subtitles: {
                            original: []
                        }
                    });
                    expect(this.model.getPosition(0)).toBe(null);
                });
                it('if 0, returns index 0', function() {
                    expect(this.model.getPosition(0)).toBe(0);
                });
                it('if 5, returns index 0', function() {
                    expect(this.model.getPosition(5)).toBe(0);
                });
                it('if 15, returns index 1', function() {
                    expect(this.model.getPosition(15)).toBe(1);
                });
                it('if 95, returns index 9', function() {
                    expect(this.model.getPosition(95)).toBe(9);
                });
            });
            describe('doOmptimisticTimer', function() {
                it('no timer set if at max length', function() {
                    var maxLength = this.model.get('subtitles').original.length - 1;
                    this.model.set({
                        i: maxLength
                    });
                    this.model.doOmptimisticTimer(95000);
                    expect(this.model.timer).toBe(null);
                });
                it('timer set if less than a second left before next subtitle', function() {
                    var nextTs = this.model.get('subtitles').original[1].ts;
                    var diff = 500;
                    spyOn(this.model, 'setTimer');
                    this.model.doOmptimisticTimer(nextTs - diff);
                    expect(this.model.setTimer).toHaveBeenCalled();
                    expect(this.model.setTimer.mostRecentCall.args[1]).toEqual(diff);
                });
                it('no timer set if more than a second left before next subtitle', function() {
                    var nextTs = this.model.get('subtitles').original[1].ts;
                    spyOn(this.model, 'setTimer');
                    this.model.doOmptimisticTimer(nextTs - 1500);
                    expect(this.model.setTimer).not.toHaveBeenCalled();
                });
            });
        });

        describe('View', function() {
            beforeEach(function() {
                this.view = helpers.createTestView();
                this.el = this.view.render().el;
                this.model = this.view.model;
                $('.example').html(this.el);
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
        });

        describe('Visual Check', function() {
            it('Show example', function() {
                $('.example').html(helpers.createTestView().render().el);
            });
        });
    });

});