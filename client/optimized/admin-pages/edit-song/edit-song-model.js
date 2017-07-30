(function() {
  define(['backbone', 'youtube.sync.model', 'underscore', 'jquery'], function(Backbone, SyncModel, _, $) {
    var EditSongModel;
    EditSongModel = Backbone.Model.extend({
      initialize: function() {
        this.syncModel = new SyncModel();
        return this.getSong();
      },
      getSong: function() {
        var _this = this;
        return $.ajax({
          type: 'GET',
          url: '/api/songs/' + this.get('id'),
          dataType: 'json',
          success: function(song) {
            _this.set({
              data: song
            });
            _this.trigger('change');
            return _this.syncModel.set({
              currentSong: song
            });
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      },
      saveSubtitles: function(subtitlesText) {
        var line, lines, song, subtitle, subtitles, success, ts, _i, _len,
          _this = this;
        subtitles = [];
        if (subtitlesText && subtitlesText.length > 0) {
          lines = subtitlesText.split('\n');
          ts = 0;
          for (_i = 0, _len = lines.length; _i < _len; _i++) {
            line = lines[_i];
            subtitle = {
              text: line,
              ts: ts
            };
            subtitles.push(subtitle);
            ts += 1500;
          }
        }
        song = this.get('data');
        song.subtitles = subtitles;
        success = function() {
          return _this.trigger('change');
        };
        return this.saveSong(song, success);
      },
      saveSync: function() {
        var song, subtitles, success,
          _this = this;
        subtitles = this.syncModel.get('currentSong').subtitles;
        song = this.get('data');
        song.subtitles = subtitles;
        success = function() {
          return _this.trigger('change');
        };
        return this.saveSong(song, success);
      },
      saveTranslation: function(translationText) {
        var firstTranslation, song, success, translation, _ref,
          _this = this;
        translation = translationText != null ? translationText.split('\n') : void 0;
        song = this.get('data');
        if (((_ref = song.translations) != null ? _ref.length : void 0) > 0) {
          song.translations[0].data = translation;
        } else {
          firstTranslation = {
            language: this.get('settings').get('toLanguage').language,
            data: translation
          };
          song.translations = [firstTranslation];
        }
        success = function() {
          return _this.trigger('change');
        };
        return this.saveSong(song, success);
      },
      saveSong: function(song, success) {
        var _this = this;
        console.log(JSON.stringify(song));
        return $.ajax({
          type: 'PUT',
          url: '/api/songs/' + this.get('id'),
          data: {
            song: song
          },
          success: function(res) {
            return typeof success === "function" ? success() : void 0;
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      }
    });
    return EditSongModel;
  });

}).call(this);

/*
//@ sourceMappingURL=edit-song-model.js.map
*/