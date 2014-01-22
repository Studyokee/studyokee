'use strict';

define(['song.list.view', 'backbone', 'jquery'], function (SongListView, Backbone, $) {

    var helpers = {
        createTestView: function () {
            var songs = [];
            for (var i = 0; i < 10; i++) {
                songs.push({
                    name: 'Test Song Name',
                    artist: 'Test Artist',
                    icon: 'http://rdio-a.cdn3.rdio.com/album/1/6/e/000000000002ce61/2/square-200.jpg'
                });
            }

            var view = new SongListView({
                model: new Backbone.Model({
                    songs: songs
                })
            });
            return view;
        }
    };

    describe('SongList', function() {
        describe('Visual Check', function() {
            it('Show example', function() {
                $('.example').html(helpers.createTestView().render().el);
            });
        });
    });

});