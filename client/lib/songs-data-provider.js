(function() {
  define(function() {
    var SongsDataProvider;
    SongsDataProvider = (function() {
      function SongsDataProvider(settings) {
        this.settings = settings;
        this.lastSong = '';
        this.url = '/api';
      }

      SongsDataProvider.prototype.getSegments = function(_id, language, callback) {
        var currentSong, onSuccess, startTime, subtitles, subtitlesRetrieved, translation, translationRetrieved, _ref,
          _this = this;
        console.log('DATA PROVIDER: getSegments');
        if ((_ref = this.settings) != null ? _ref.get('enableLogging') : void 0) {
          startTime = new Date().getTime();
        }
        this.lastSong = currentSong = _id;
        subtitlesRetrieved = false;
        translationRetrieved = false;
        subtitles = [];
        translation = [];
        onSuccess = function() {
          var endTime, song, _ref1;
          if (currentSong === !_this.lastSong) {
            return;
          }
          if (subtitlesRetrieved && translationRetrieved) {
            song = {
              original: subtitles,
              translation: translation
            };
            if ((_ref1 = _this.settings) != null ? _ref1.get('enableLogging') : void 0) {
              endTime = new Date().getTime();
              console.log('DATA PROVIDER: time to load lyrics and translation in ' + (endTime - startTime) + ' after: ' + (endTime - _this.settings.get('loadStartTime')) + ' since start, (' + endTime + ')');
            }
            return callback(song);
          }
        };
        console.log('DATA PROVIDER: get ' + this.url + '/songs/' + _id + '/translations/' + language);
        $.ajax({
          type: 'GET',
          url: this.url + '/songs/' + _id + '/translations/' + language,
          success: function(res) {
            var endTime, _ref1;
            if ((_ref1 = _this.settings) != null ? _ref1.get('enableLogging') : void 0) {
              endTime = new Date().getTime();
              console.log('DATA PROVIDER: retrieved translation in: ' + (endTime - startTime) + ', (' + new Date().getTime() + ')');
            }
            translation = res;
            translationRetrieved = true;
            return onSuccess();
          },
          error: function(err) {
            console.log('DATA PROVIDER: error retrieving translation: ' + err);
            translationRetrieved = true;
            return onSuccess();
          }
        });
        return $.ajax({
          type: 'GET',
          url: this.url + '/songs/' + _id + '/subtitles',
          success: function(res) {
            var endTime, _ref1;
            if ((_ref1 = _this.settings) != null ? _ref1.get('enableLogging') : void 0) {
              endTime = new Date().getTime();
              console.log('DATA PROVIDER: retrieved subtitles in: ' + (endTime - startTime) + ', (' + new Date().getTime() + ')');
            }
            subtitles = res;
            subtitlesRetrieved = true;
            return onSuccess();
          },
          error: function(err) {
            console.log('DATA PROVIDER: error retrieving subtitles: ' + err);
            subtitlesRetrieved = true;
            return onSuccess();
          }
        });
      };

      SongsDataProvider.prototype.saveTranslation = function(_id, toLanguage, translation, callback) {
        var _ref;
        if ((_ref = this.settings) != null ? _ref.get('enableLogging') : void 0) {
          console.log('DATA PROVIDER: save translation for \'' + _id + '\' in \'' + toLanguage + '\'');
        }
        return $.ajax({
          type: 'PUT',
          url: this.url + '/songs/' + _id + '/translations/' + toLanguage,
          data: {
            translation: translation
          },
          success: function() {
            console.log('success save');
            return callback();
          },
          error: function(err) {
            console.log('err:' + err);
            return callback();
          }
        });
      };

      SongsDataProvider.prototype.saveSubtitles = function(_id, subtitles, callback) {
        var _ref;
        if ((_ref = this.settings) != null ? _ref.get('enableLogging') : void 0) {
          console.log('DATA PROVIDER: save original for \'' + _id + '\'');
        }
        return $.ajax({
          type: 'PUT',
          url: this.url + '/songs/' + _id + '/subtitles',
          data: {
            subtitles: subtitles
          },
          success: function() {
            console.log('success save');
            return callback();
          },
          error: function(err) {
            console.log('err:' + err);
            return callback();
          }
        });
      };

      return SongsDataProvider;

    })();
    return SongsDataProvider;
  });

}).call(this);

/*
//@ sourceMappingURL=songs-data-provider.js.map
*/