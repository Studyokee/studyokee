(function() {
  define(['backbone', 'handlebars', 'youtube.sync.view', 'jquery', 'purl', 'templates'], function(Backbone, Handlebars, SyncView, $) {
    var EditSongView;
    EditSongView = Backbone.View.extend({
      initialize: function() {
        var _this = this;
        this.syncView = new SyncView({
          model: this.model.syncModel
        });
        return this.listenTo(this.model, 'change', function() {
          return _this.render();
        });
      },
      render: function() {
        var model, song, that, _ref, _ref1, _ref2, _ref3, _ref4, _ref5,
          _this = this;
        song = this.model.get('data');
        model = {
          data: song
        };
        if (song) {
          model.lyrics = this.formatData(song);
        }
        this.$el.html(Handlebars.templates['edit-song'](model));
        song = this.model.get('data');
        this.$('.songDetails input').blur(function() {
          if (!song.metadata) {
            song.metadata = {};
          }
          song.metadata.trackName = _this.$('#trackName').val();
          song.metadata.artist = _this.$('#artist').val();
          song.youtubeKey = $.url(_this.$('#youtubeKey').val()).param('v');
          return _this.model.saveSong(song);
        });
        that = this;
        this.$('.editSubtitleLineLink').click(function() {
          return $(this).find('.editSubtitleLine').removeClass('textInput');
        });
        this.$('.editSubtitleLine').blur(function() {
          var index, newVal, parent, _ref, _ref1, _ref2, _ref3,
            _this = this;
          parent = $(this).closest('tr');
          index = parent.attr('data-index');
          newVal = $.trim($(this).val());
          if ((_ref = that.model.get('data')) != null ? _ref.subtitles[index] : void 0) {
            if ((_ref1 = that.model.get('data')) != null) {
              if ((_ref2 = _ref1.subtitles[index]) != null) {
                _ref2.text = newVal;
              }
            }
          } else {
            if ((_ref3 = that.model.get('data')) != null) {
              _ref3.subtitles[index] = {
                text: newVal,
                ts: 0
              };
            }
          }
          $(this).addClass('textInput');
          return that.model.saveSong(that.model.get('data'), function() {
            return that.trigger('change');
          });
        });
        this.$('.editTranslationLineLink').click(function() {
          return $(this).find('.editTranslationLine').removeClass('textInput');
        });
        this.$('.editTranslationLine').blur(function() {
          var index, newVal, parent, _ref, _ref1, _ref2,
            _this = this;
          parent = $(this).closest('tr');
          index = parent.attr('data-index');
          newVal = $.trim($(this).val());
          if ((_ref = that.model.get('data')) != null) {
            if ((_ref1 = _ref.translations[0]) != null) {
              if ((_ref2 = _ref1.data) != null) {
                _ref2[index] = newVal;
              }
            }
          }
          $(this).addClass('textInput');
          return that.model.saveSong(that.model.get('data'), function() {
            return that.trigger('change');
          });
        });
        if (((_ref = model.data) != null ? (_ref1 = _ref.subtitles) != null ? _ref1.length : void 0 : void 0) <= 0) {
          this.$('.clearSubtitles').hide();
          this.$('.syncSubtitles').hide();
        }
        if (((_ref2 = model.data) != null ? (_ref3 = _ref2.translations) != null ? (_ref4 = _ref3[0]) != null ? (_ref5 = _ref4.data) != null ? _ref5.length : void 0 : void 0 : void 0 : void 0) <= 0) {
          this.$('.clearTranslation').hide();
        }
        this.$('.uploadSubtitles').on('click', function() {
          _this.$('.editSubtitlesModal').show();
          _this.$('.editSubtitlesModal .modal').show();
          return _this.$('#subtitlesEdit').focus();
        });
        this.$('.clearSubtitles').on('click', function() {
          confirm('Delete subtitles for this song?');
          return _this.model.saveSubtitles();
        });
        this.$('.uploadTranslation').on('click', function() {
          _this.$('.editTranslationModal').show();
          _this.$('.editTranslationModal .modal').show();
          return _this.$('#translationEdit').focus();
        });
        this.$('.clearTranslation').on('click', function() {
          confirm('Delete translation for this song?');
          return _this.model.saveTranslation();
        });
        this.$('.closeEditSubtitlesModal').click(function() {
          return _this.$('.editSubtitlesModal').hide();
        });
        this.$('.saveSubtitles').click(function() {
          return _this.model.saveSubtitles(_this.$('#subtitlesEdit').val());
        });
        this.$('.syncSubtitles').click(function() {
          _this.$('.syncSubtitlesModal').show();
          _this.$('.syncSubtitlesModal .modal').show();
          if (_this.$('.syncSubtitlesContainer').html().length === 0) {
            return _this.$('.syncSubtitlesContainer').html(_this.syncView.render().el);
          }
        });
        this.$('.closeSyncSubtitlesModal').click(function() {
          _this.$('.syncSubtitlesModal').hide();
          _this.model.syncModel.reset();
          return typeof window.subtitlesControlsTeardown === "function" ? window.subtitlesControlsTeardown() : void 0;
        });
        this.$('.saveSyncSubtitles').click(function() {
          _this.model.syncModel.reset();
          return _this.model.saveSync();
        });
        this.$('.closeTranslationModal').click(function() {
          return _this.$('.editTranslationModal').hide();
        });
        this.$('.saveTranslation').click(function() {
          return _this.model.saveTranslation(_this.$('#translationEdit').val());
        });
        return this;
      },
      formatData: function(song) {
        var formattedData, i, length, subtitleLine, subtitles, translation, translationLine, _i, _ref, _ref1, _ref2;
        subtitles = song.subtitles;
        translation = (_ref = song.translations) != null ? (_ref1 = _ref[0]) != null ? _ref1.data : void 0 : void 0;
        length = Math.max((subtitles != null ? subtitles.length : void 0) || 0, (translation != null ? translation.length : void 0) || 0);
        formattedData = [];
        if (length > 0) {
          for (i = _i = 0, _ref2 = length - 1; 0 <= _ref2 ? _i <= _ref2 : _i >= _ref2; i = 0 <= _ref2 ? ++_i : --_i) {
            translationLine = '';
            subtitleLine = {};
            if ((translation != null ? translation.length : void 0) > i) {
              translationLine = translation[i];
            }
            if ((subtitles != null ? subtitles.length : void 0) > i) {
              subtitleLine = subtitles[i];
            }
            formattedData.push({
              text: subtitleLine != null ? subtitleLine.text : void 0,
              translation: translationLine,
              ts: (subtitleLine != null ? subtitleLine.ts : void 0) || 0,
              i: i
            });
          }
        }
        return formattedData;
      },
      createTextFromSubtitles: function(subtitles) {
        var line, text, _i, _len;
        if (subtitles == null) {
          return '';
        }
        text = '';
        for (_i = 0, _len = subtitles.length; _i < _len; _i++) {
          line = subtitles[_i];
          text += line.text + '\n';
        }
        return text;
      },
      createSubtitlesFromText: function(text) {
        var line, lines, regexText, regexTs, subtitle, subtitles, textMatch, tsMatch, _i, _len;
        lines = text.split('\n');
        subtitles = [];
        for (_i = 0, _len = lines.length; _i < _len; _i++) {
          line = lines[_i];
          regexTs = /\[(.*)\]/;
          tsMatch = line.match(regexTs);
          regexText = /\[.*\](.*)/;
          textMatch = line.match(regexText);
          if ((tsMatch != null ? tsMatch.length : void 0) === 2 && (textMatch != null ? textMatch.length : void 0) === 2) {
            subtitle = {
              text: textMatch[1],
              ts: tsMatch[1]
            };
            subtitles.push(subtitle);
          }
        }
        return subtitles;
      }
    });
    return EditSongView;
  });

}).call(this);

/*
//@ sourceMappingURL=edit-song-view.js.map
*/