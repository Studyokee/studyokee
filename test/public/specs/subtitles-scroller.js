'use strict';

define(['subtitles.scroller.view', 'backbone', 'jquery'], function (SubtitlesScrollerView, Backbone, $) {

    var helpers = {
        checkOnlyIndexSelected: function (parent, i) {
            $(parent).find('.subtitles li').each(function (index, el) {
                if (index === i) {
                    expect($(el).hasClass('active')).toBe(true);
                } else {
                    expect($(el).hasClass('active')).toBe(false);
                }
            });
        },
        createTestView: function () {
            var subtitles = [];
            var translation = [];
            for (var i = 0; i < 10; i++) {
                subtitles.push({ text: 'test', ts: 0 });
                translation.push('examen');
            }
            var model = new Backbone.Model({
                i: 0,
                subtitles: subtitles,
                translation: translation
            });
            var view = new SubtitlesScrollerView({
                model: model
            });
            return view;
        }
    };

    describe('SubtitlesScroller', function() {
        describe('View', function() {
            beforeEach(function() {
                this.view = helpers.createTestView();
                this.el = this.view.render().el;
            });

            describe('On update of i', function() {
                it('shifts the top margin correctly', function() {
                    this.view.model.set({
                        i: 0
                    });
                    var topMargin = $(this.el).find('.subtitles').css('margin-top');
                    expect(topMargin).toBe('0px');

                    this.view.model.set({
                        i: 1
                    });
                    topMargin = $(this.el).find('.subtitles').css('margin-top');
                    expect(topMargin).toBe('0px');

                    var pageHeight = this.view.lineHeight * this.view.pageSize;
                    this.view.model.set({
                        i: 5
                    });
                    topMargin = $(this.el).find('.subtitles').css('margin-top');
                    expect(topMargin).toBe(-pageHeight + 'px');

                    this.view.model.set({
                        i: 9
                    });
                    topMargin = $(this.el).find('.subtitles').css('margin-top');
                    expect(topMargin).toBe((-pageHeight * 2) + 'px');
                });
                it('does not go past the last page', function() {
                    this.view.model.set({
                        i: 20
                    });
                    var topMargin = $(this.el).find('.subtitles').css('margin-top');
                    var pageHeight = this.view.lineHeight * this.view.pageSize;
                    expect(topMargin).toBe((-pageHeight * 2) + 'px');
                });
                it('does not go before the first page', function() {
                    this.view.model.set({
                        i: -1
                    });
                    var topMargin = $(this.el).find('.subtitles').css('margin-top');
                    expect(topMargin).toBe('0px');
                });

                it('selects the correct line', function () {

                    this.view.model.set({
                        i: 0
                    });
                    helpers.checkOnlyIndexSelected(this.el, 0);

                    this.view.model.set({
                        i: 1
                    });
                    helpers.checkOnlyIndexSelected(this.el, 1);

                    this.view.model.set({
                        i: 9
                    });
                    helpers.checkOnlyIndexSelected(this.el, 9);
                });
                it('doesn\'t select before 0', function () {
                    this.view.model.set({
                        i: -1
                    });
                    helpers.checkOnlyIndexSelected(this.el, 0);
                });
                it('doesn\'t select after last', function () {
                    this.view.model.set({
                        i: 10
                    });
                    helpers.checkOnlyIndexSelected(this.el, 9);
                });
            });

            describe('Function getFormattedData', function() {
                it('does not fail on no subtitles', function() {
                    var result = this.view.getFormattedData(null, ['test']);
                    expect(result.length).toBe(0);
                    result = this.view.getFormattedData([], ['test']);
                    expect(result.length).toBe(0);
                });
                it('does not fail on no translation', function() {
                    var result = this.view.getFormattedData([{
                        text: 'test',
                        ts: 0
                    }], []);
                    expect(result.length).toBe(1);

                    result = this.view.getFormattedData([{
                        text: 'test',
                        ts: 0
                    }], null);
                    expect(result.length).toBe(1);
                });
                it('does not fail when translation shorter than subtitles', function() {
                    var result = this.view.getFormattedData([{
                        text: 'test',
                        ts: 0
                    },{
                        text: 'test2',
                        ts: 1
                    }], ['test']);
                    expect(result.length).toBe(2);
                });
            });

            describe('On update of subtitles', function() {
                it('if no subtitles, render no subtitles message', function() {
                    expect($(this.el).find('.no-subtitles').length).toBe(0);

                    this.view.model.set({
                        subtitles: [],
                        translation: []
                    });
                    expect($(this.el).find('.no-subtitles').length).toBe(1);
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