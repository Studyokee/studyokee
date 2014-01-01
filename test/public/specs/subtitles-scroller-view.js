'use strict';

define(['subtitles.scroller.view', 'backbone'], function (SubtitlesScrollerView, Backbone) {

    var view = new SubtitlesScrollerView({
        model: new Backbone.Model({
            i: 0,
            subtitles: {
                original: [
                    {
                        text: 'test',
                        ts: 0
                    }
                ],
                translation: ['examen']
            }
        })
    });

    describe('subtitles scroller view', function() {
        it('shiftPage', function() {
            // Update to use dom
            view.shiftPage(0);
            var topMargin = 0;
            expect(topMargin).toBe(0);

            view.shiftPage(3);
            topMargin = 0;
            expect(topMargin).toBe(0);

            view.shiftPage(4);
            topMargin = -384;
            expect(topMargin).toBe(-384);

            view.shiftPage(9);
            topMargin = -768;
            expect(topMargin).toBe(-768);
        });
        it('selectLine', function() {
            // check correct line has selected class
        });
    });

});