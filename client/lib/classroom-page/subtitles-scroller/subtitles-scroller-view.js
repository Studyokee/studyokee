(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var SubtitlesScrollerView;
    SubtitlesScrollerView = Backbone.View.extend({
      className: "subtitles-scroller show-translation",
      pageSize: 3,
      initialize: function() {
        var _this = this;
        this.listenTo(this.model, 'change:i', function() {
          var i;
          i = _this.model.get('i');
          if (i >= _this.model.getLength() || i < 0) {
            return;
          }
          return _this.adjustView();
        });
        this.listenTo(this.model, 'change:formattedData', function() {
          return _this.render();
        });
        return this.on('toggleTranslation', function() {
          _this.$el.toggleClass('show-translation');
          return _this.adjustView();
        });
      },
      render: function() {
        var length, lookup, that,
          _this = this;
        length = this.model.getLength();
        if (length === null) {
          this.$el.html(this.getLoadingMessage());
        } else if (length === []) {
          this.$el.html(this.getNoSubtitlesMessage());
        } else {
          this.$el.html(Handlebars.templates['subtitles-scroller']({
            data: this.model.get('formattedData')
          }));
          lookup = function(event) {
            var query;
            console.log('clicked lookup');
            query = $(event.target).attr('data-lookup');
            _this.trigger('lookup', query);
            $(event.target).focus;
            event.preventDefault();
            return event.stopPropagation();
          };
          this.$('.subtitles a').click(lookup);
          this.adjustView();
          that = this;
          $('.subtitle').click(function() {
            console.log('clicked line');
            return that.trigger('selectLine', $(this).index());
          });
        }
        return this;
      },
      getLoadingMessage: function() {
        return '<span class="glyphicon glyphicon-refresh glyphicon-spin large-spinner"></span>';
      },
      getNoSubtitlesMessage: function() {
        return '<div class="no-subtitles">Sorry, there are no subtitles for this song</div>';
      },
      adjustView: function() {
        var i;
        i = this.model.get('i');
        this.shiftPage(i);
        return this.selectLine(i);
      },
      shiftPage: function(i) {
        var page, topMargin;
        this.lineHeight = this.$('li.subtitle').outerHeight(true);
        page = Math.floor(i / this.pageSize);
        topMargin = -(page * (this.pageSize * this.lineHeight));
        return this.$('.subtitles').css('margin-top', topMargin + 'px');
      },
      selectLine: function(i) {
        return this.$('.subtitles .subtitle').each(function(index, el) {
          if (index === i) {
            return $(el).addClass('active');
          } else {
            return $(el).removeClass('active');
          }
        });
      }
    });
    return SubtitlesScrollerView;
  });

}).call(this);

/*
//@ sourceMappingURL=subtitles-scroller-view.js.map
*/