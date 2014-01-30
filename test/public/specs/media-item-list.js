'use strict';

define(['media.item.list.view', 'backbone', 'jquery'], function (MediaItemListView, Backbone, $) {

    var helpers = {
        createTestView: function () {
            var data = [];
            for (var i = 0; i < 10; i++) {
                data.push({
                    title: 'Test Song Name',
                    description: 'Test Artist',
                    icon: 'http://rdio-a.cdn3.rdio.com/album/1/6/e/000000000002ce61/2/square-200.jpg'
                });
            }

            var view = new MediaItemListView({
                model: new Backbone.Model({
                    data: data
                })
            });
            return view;
        }
    };

    describe('MediaItemList', function() {
        describe('Visual Check', function() {
            it('Show example', function() {
                $('.example').html(helpers.createTestView().render().el);
            });
        });
    });

});