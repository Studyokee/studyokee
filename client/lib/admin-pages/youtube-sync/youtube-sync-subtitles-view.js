(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var YoutubeSyncSubtitlesView;
    YoutubeSyncSubtitlesView = Backbone.View.extend({
      className: 'youtube-sync-subtitles',
      pageSize: 1,
      initialize: function() {
        var _this = this;
        this.listenTo(this.model, 'change:i', function() {
          return _this.onPositionChange();
        });
        this.on('sizeChange', function() {
          return _this.onPositionChange();
        });
        return this.listenTo(this.model, 'updateSubtitles', function() {
          return _this.render();
        });
      },
      render: function() {
        var insertAfter, insertBefore, insertTextAfter, insertTextBefore, view,
          _this = this;
        this.$el.html(Handlebars.templates['youtube-sync-subtitles'](this.model.toJSON().currentSong));
        view = this;
        this.$('.edit').on('click', function() {
          var index, liElement, wireInput,
            _this = this;
          liElement = $(this).parent('li');
          index = liElement.attr('data-index');
          liElement.find('.original-subtitle').hide();
          liElement.find('.updateLine').show();
          liElement.find('.toAdd').focus();
          liElement.find('.toAdd').val(liElement.find('.subtitle-text').html());
          wireInput = function() {
            var replaceLine;
            if (liElement.attr('data-wired')) {
              return;
            }
            replaceLine = function() {
              var text;
              text = liElement.find('.toAdd').val();
              if ((text != null ? text.length : void 0) > 0) {
                return view.model.splice(view.model.get('i'), 1, text);
              }
            };
            liElement.find('.toAdd').keydown(function(event) {
              if (event.which === 13) {
                replaceLine();
                return event.preventDefault();
              }
            });
            liElement.find('.toAdd').keyup(function(event) {
              if (liElement.find('.toAdd').val()) {
                liElement.find('.addLine').removeClass('btn-default');
                return liElement.find('.addLine').addClass('btn-primary');
              } else {
                liElement.find('.addLine').removeClass('btn-primary');
                return liElement.find('.addLine').addClass('btn-default');
              }
            });
            liElement.find('.addLine').on('click', replaceLine);
            return liElement.attr('data-wired', true);
          };
          wireInput();
          return view.model.pause();
        });
        this.$('.remove').on('click', function() {
          var index;
          index = $(this).parent('li').attr('data-index');
          return view.model.removeLine(index);
        });
        insertBefore = this.$('.insertBefore');
        insertTextBefore = function() {
          var text;
          text = insertBefore.find('.toAdd').val();
          if ((text != null ? text.length : void 0) > 0) {
            return view.model.splice(view.model.get('i'), 0, text);
          }
        };
        insertBefore.find('.toAdd').keydown(function(event) {
          if (event.which === 13) {
            insertTextBefore();
            return event.preventDefault();
          }
        });
        insertBefore.find('.toAdd').keyup(function(event) {
          if (insertBefore.find('.toAdd').val()) {
            insertBefore.find('.addLine').removeClass('btn-default');
            return insertBefore.find('.addLine').addClass('btn-primary');
          } else {
            insertBefore.find('.addLine').removeClass('btn-primary');
            return insertBefore.find('.addLine').addClass('btn-default');
          }
        });
        insertBefore.find('.openInsert').on('click', function() {
          insertBefore.find('.openInsert').hide();
          insertBefore.find('.insertLine').show();
          return insertBefore.find('.toAdd').focus();
        });
        insertBefore.find('.addLine').on('click', insertTextBefore);
        insertAfter = this.$('.insertAfter');
        insertTextAfter = function() {
          var text;
          text = insertAfter.find('.toAdd').val();
          if ((text != null ? text.length : void 0) > 0) {
            return view.model.splice(view.model.get('i') + 1, 0, text);
          }
        };
        insertAfter.find('.toAdd').keydown(function(event) {
          if (event.which === 13) {
            insertTextAfter();
            return event.preventDefault();
          }
        });
        insertAfter.find('.toAdd').keyup(function(event) {
          if (insertAfter.find('.toAdd').val()) {
            insertAfter.find('.addLine').removeClass('btn-default');
            return insertAfter.find('.addLine').addClass('btn-primary');
          } else {
            insertAfter.find('.addLine').removeClass('btn-primary');
            return insertAfter.find('.addLine').addClass('btn-default');
          }
        });
        insertAfter.find('.openInsert').on('click', function() {
          insertAfter.find('.openInsert').hide();
          insertAfter.find('.insertLine').show();
          return insertAfter.find('.toAdd').focus();
        });
        insertAfter.find('.addLine').on('click', insertTextAfter);
        this.onPositionChange();
        return this;
      },
      getLength: function() {
        var subtitles, _ref;
        subtitles = (_ref = this.model.get('currentSong')) != null ? _ref.subtitles : void 0;
        if (subtitles) {
          return subtitles.length;
        } else {
          return 0;
        }
      },
      onPositionChange: function() {
        var i, length;
        i = this.model.get('i');
        length = this.getLength();
        if (i >= length) {
          i = length - 1;
        }
        if (i < 0) {
          i = 0;
        }
        this.shiftPage(i);
        return this.selectLine(i);
      },
      shiftPage: function(i) {
        var page, topMargin;
        this.lineHeight = this.$('li.subtitle').outerHeight(true);
        page = Math.floor(i / this.pageSize);
        if (page !== 0) {
          page--;
        }
        topMargin = -(page * (this.pageSize * this.lineHeight));
        return this.$('.subtitles').css('margin-top', topMargin + 'px');
      },
      selectLine: function(i) {
        var insertAfterButton, insertBeforeButton;
        insertBeforeButton = this.$('.insertBefore');
        insertAfterButton = this.$('.insertAfter');
        return this.$('.subtitles .subtitle').each(function(index, el) {
          if (index === i) {
            insertBeforeButton.insertBefore(el);
            insertAfterButton.insertAfter(el);
            return $(el).addClass('active');
          } else {
            return $(el).removeClass('active');
          }
        });
      }
    });
    return YoutubeSyncSubtitlesView;
  });

}).call(this);

/*
//@ sourceMappingURL=youtube-sync-subtitles-view.js.map
*/