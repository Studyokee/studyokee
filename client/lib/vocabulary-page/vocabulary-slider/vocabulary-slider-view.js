(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var VocabularySliderView;
    VocabularySliderView = Backbone.View.extend({
      tagName: 'div',
      className: 'vocabulary-slider',
      initialize: function() {
        var _this = this;
        this.listenTo(this.model, 'change', function() {
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
      teardown: function() {
        return $(window).off('keydown', this.onKeyDownEvent);
      },
      render: function() {
        var _this = this;
        if (this.model.get('words') === null) {
          this.$el.html('<span class="glyphicon glyphicon-refresh glyphicon-spin large-spinner"></span>');
        } else if (this.model.get('words').length === 0) {
          this.$el.html('<div class="noResults">No words to study!</div>');
        } else {
          this.$el.html(Handlebars.templates['vocabulary-slider'](this.model.toJSON()));
          $(this.$el.find('.card')[this.model.get('index')]).addClass('active');
          this.$('.next').on('click', function() {
            return _this.next();
          });
          this.$('.prev').on('click', function() {
            return _this.prev();
          });
          this.$('.remove').on('click', function() {
            return _this.remove();
          });
          this.$('.panel-link').on('click', function() {
            return _this.next();
          });
          this.$('[data-toggle="popover"]').popover();
        }
        this.$('#editCardModal').on('show.bs.modal', function() {
          var currentWord;
          currentWord = _this.model.get('words')[_this.model.get('index')];
          _this.$('#editCardModal .cardWord').text(currentWord.word);
          return _this.$('#editCardModal .cardDef').val(currentWord.def);
        });
        this.$('#editCardModal .saveCard').click(function() {
          return _this.edit();
        });
        return this;
      },
      next: function() {
        if (this.$('.flip-container').hasClass('flip')) {
          this.model.set({
            index: (this.model.get('index') + 1) % this.model.get('words').length
          });
          return this.model.trigger('change');
        } else {
          return this.$('.flip-container').addClass('flip');
        }
      },
      edit: function() {
        var currentWord;
        currentWord = this.model.get('words')[this.model.get('index')];
        currentWord.def = this.$('#editCardModal .cardDef').val();
        if (currentWord.def) {
          $('#editCardModal').modal('hide');
          $('body').removeClass('modal-open');
          $('.modal-backdrop').remove();
          this.model.trigger('updateWord', currentWord);
          return this.render();
        }
      },
      remove: function() {
        return this.model.remove(this.model.get('index'));
      },
      onKeyDown: function(event) {
        if (event.which === 39) {
          this.next();
          event.preventDefault();
        }
        if (event.which === 32) {
          this.remove();
          return event.preventDefault();
        }
      }
    });
    return VocabularySliderView;
  });

}).call(this);

/*
//@ sourceMappingURL=vocabulary-slider-view.js.map
*/