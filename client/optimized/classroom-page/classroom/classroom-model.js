(function() {
  define(['media.item.list.model', 'dictionary.model', 'songs.data.provider', 'youtube.player.model', 'subtitles.scroller.model', 'backbone'], function(MenuModel, DictionaryModel, SongsDataProvider, YoutubePlayerModel, SubtitlesScrollerModel, Backbone) {
    var ClassroomModel;
    ClassroomModel = Backbone.Model.extend({
      initialize: function() {
        var _this = this;
        this.dataProvider = new SongsDataProvider(this.get('settings'));
        this.menuModel = new MenuModel({
          settings: this.get('settings')
        });
        this.subtitlesScrollerModel = new SubtitlesScrollerModel({
          settings: this.get('settings')
        });
        this.youtubePlayerModel = new YoutubePlayerModel({
          settings: this.get('settings')
        });
        this.dictionaryModel = new DictionaryModel({
          settings: this.get('settings'),
          vocabulary: this.get('vocabulary')
        });
        this.on('change:currentSong', function() {
          _this.youtubePlayerModel.set({
            currentSong: _this.get('currentSong')
          });
          _this.subtitlesScrollerModel.set({
            currentSong: _this.get('currentSong')
          });
          if (_this.get('currentSong')) {
            return _this.getSongData(_this.get('currentSong')._id);
          }
        });
        this.on('change:songData', function() {
          _this.youtubePlayerModel.set({
            songData: _this.get('songData')
          });
          return _this.subtitlesScrollerModel.set({
            songData: _this.get('songData')
          });
        });
        this.on('change:vocabulary', function() {
          return _this.subtitlesScrollerModel.set({
            vocabulary: _this.get('vocabulary')
          });
        });
        this.dictionaryModel.on('wordAdded', function(vocabulary) {
          return _this.set({
            vocabulary: vocabulary
          });
        });
        this.on('change:classroom', function() {
          var currentSong, displayInfos, title;
          displayInfos = _this.get('displayInfos');
          _this.menuModel.set({
            rawData: displayInfos
          });
          _this.set({
            songDisplayInfos: displayInfos
          });
          title = _this.getHash();
          currentSong = _this.chooseSong(title);
          return _this.set({
            currentSong: currentSong
          });
        });
        this.youtubePlayerModel.on('change:i', function() {
          return _this.subtitlesScrollerModel.set({
            i: _this.youtubePlayerModel.get('i')
          });
        });
        this.getClassroom();
        return this.getVocabulary();
      },
      chooseSong: function(title) {
        var displayInfos, index, info, songIndex, _i, _len;
        displayInfos = this.get('songDisplayInfos');
        if ((displayInfos != null ? displayInfos.length : void 0) > 0) {
          songIndex = 0;
          if (title) {
            for (index = _i = 0, _len = displayInfos.length; _i < _len; index = ++_i) {
              info = displayInfos[index];
              if (info.song.metadata.trackName === title) {
                songIndex = index;
                break;
              }
            }
          }
          return displayInfos[songIndex].song;
        }
        return null;
      },
      getHash: function() {
        var hash;
        if (document.location.hash.length > 0) {
          hash = document.location.hash.substring(1);
          if (hash.length > 0) {
            return hash;
          }
        }
        return null;
      },
      getClassroom: function() {
        var _this = this;
        return $.ajax({
          type: 'GET',
          url: '/api/classrooms/' + this.get('id'),
          dataType: 'json',
          success: function(res) {
            return _this.set({
              classroom: res.classroom,
              displayInfos: res.displayInfos
            });
          },
          error: function(err) {
            return console.log('Error fetching classroom data');
          }
        });
      },
      getVocabulary: function() {
        var fromLanguage, toLanguage,
          _this = this;
        fromLanguage = this.get('settings').get('fromLanguage').language;
        toLanguage = this.get('settings').get('toLanguage').language;
        return $.ajax({
          type: 'GET',
          url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage,
          dataType: 'json',
          success: function(res) {
            return _this.set({
              vocabulary: res != null ? res.words : void 0
            });
          },
          error: function(err) {
            return console.log('Error getting user vocabulary');
          }
        });
      },
      getSongData: function(id, callback) {
        var _this = this;
        if (id == null) {
          return;
        }
        this.set({
          lastCallbackId: id
        });
        return $.ajax({
          type: 'GET',
          url: '/api/songs/' + id,
          dataType: 'json',
          success: function(songData) {
            if ((songData != null ? songData._id : void 0) === _this.get('lastCallbackId')) {
              return _this.set({
                songData: songData
              });
            }
          },
          error: function(err) {
            return console.log('Error fetching song data');
          }
        });
      }
    });
    return ClassroomModel;
  });

}).call(this);

/*
//@ sourceMappingURL=classroom-model.js.map
*/