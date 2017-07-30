(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var SubtitlesControlsView;
    SubtitlesControlsView = Backbone.View.extend({
      className: "controls",
      initialize: function(options) {
        var _this = this;
        this.options = options;
        this.listenTo(this.model, 'change:state', function() {
          return _this.updatePlayButton();
        });
        this.listenTo(this.model, 'change:loadingVideo', function() {
          return _this.render();
        });
        this.onKeyDownEvent = function(event) {
          if ($(event.target).is('input') || $(event.target).is('textarea')) {
            return;
          }
          return _this.onKeyDown(event);
        };
        $(window).on('keydown', this.onKeyDownEvent);
        return window.subtitlesControlsTeardown = this.teardown;
      },
      render: function() {
        this.$el.html(Handlebars.templates['subtitles-controls'](this.model.toJSON()));
        this.$('.pause').hide();
        this.enableButtons();
        this.$('[data-toggle="popover"]').popover();
        return this;
      },
      updatePlayButton: function() {
        var togglePlayButtonIcon;
        togglePlayButtonIcon = this.$('.toggle-play .glyphicon');
        if (this.model.get('state') === 3) {
          togglePlayButtonIcon.removeClass('glyphicon-play');
          togglePlayButtonIcon.removeClass('glyphicon-pause');
          return togglePlayButtonIcon.addClass('glyphicon-spin');
        } else {
          if (this.model.get('playing')) {
            togglePlayButtonIcon.removeClass('glyphicon-play');
            togglePlayButtonIcon.removeClass('glyphicon-spin');
            return togglePlayButtonIcon.addClass('glyphicon-pause');
          } else {
            togglePlayButtonIcon.removeClass('glyphicon-pause');
            togglePlayButtonIcon.removeClass('glyphicon-spin');
            togglePlayButtonIcon.addClass('glyphicon-play');
            return clearTimeout(this.progressTick);
          }
        }
      },
      teardown: function() {
        return $(window).off('keydown', this.onKeyDownEvent);
      },
      toStart: function() {
        return this.model.toStart();
      },
      prev: function() {
        return this.model.prev();
      },
      next: function() {
        return this.model.next();
      },
      togglePlay: function() {
        if (this.model.get('playing')) {
          return this.model.pause();
        } else {
          return this.model.play();
        }
      },
      toggleTranslation: function() {
        var toggleTranslationButton;
        this.trigger('toggleTranslation');
        toggleTranslationButton = this.$('.toggle-translation');
        if (!toggleTranslationButton.hasClass('active')) {
          toggleTranslationButton.addClass('active');
          return toggleTranslationButton.text('Show English');
        } else {
          toggleTranslationButton.removeClass('active');
          return toggleTranslationButton.text('Hide English');
        }
      },
      enableButtons: function() {
        var _this = this;
        this.$('.prev').on('click', function() {
          return _this.prev();
        });
        this.$('.next').on('click', function() {
          return _this.next();
        });
        this.$('.toggle-play').on('click', function() {
          return _this.togglePlay();
        });
        return this.$('.toggle-translation').on('click', function() {
          return _this.toggleTranslation();
        });
      },
      onKeyDown: function(event) {
        if (event.which === 37) {
          this.prev();
          event.preventDefault();
        }
        if (event.which === 39) {
          this.next();
          event.preventDefault();
        }
        if (event.which === 32) {
          this.togglePlay();
          return event.preventDefault();
        }
      }
    });
    return SubtitlesControlsView;
  });

}).call(this);

/*
//@ sourceMappingURL=subtitles-controls-view.js.map
*/