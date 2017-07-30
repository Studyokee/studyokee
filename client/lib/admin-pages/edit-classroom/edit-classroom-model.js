(function() {
  define(['media.item.list.model', 'create.song.model', 'backbone'], function(MediaItemListModel, CreateSongModel, Backbone) {
    var EditClassroomModel;
    EditClassroomModel = Backbone.Model.extend({
      initialize: function() {
        this.songListModel = new MediaItemListModel();
        this.createSongModel = new CreateSongModel();
        this.songSearchListModel = new MediaItemListModel();
        return this.refreshClassroom();
      },
      refreshClassroom: function() {
        var _this = this;
        return $.ajax({
          type: 'GET',
          url: '/api/classrooms/' + this.get('id'),
          dataType: 'json',
          success: function(res) {
            _this.set({
              data: res.classroom
            });
            _this.songListModel.set({
              rawData: res.displayInfos
            });
            return _this.createSongModel.set({
              defaultLanguage: _this.get('settings').get('fromLanguage').language
            });
          },
          error: function(err) {
            return console.log('Error: ' + err.responseText);
          }
        });
      },
      addSong: function(id) {
        var ids, song, songs, _i, _len, _ref;
        if ((id == null) || id.length === 0) {
          return;
        }
        songs = this.songListModel.get('data') || [];
        ids = [];
        for (_i = 0, _len = songs.length; _i < _len; _i++) {
          song = songs[_i];
          if (!(song != null ? (_ref = song.song) != null ? _ref._id : void 0 : void 0)) {
            continue;
          }
          if (song.song._id === id) {
            return;
          }
          ids.push(song.song._id);
        }
        ids.push(id);
        return this.saveSongs(ids);
      },
      removeSong: function(id) {
        var ids, item, items, _i, _len, _ref, _ref1;
        if ((id == null) || id.length === 0) {
          return;
        }
        items = this.songListModel.get('data') || [];
        ids = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          console.log('id: ' + id);
          console.log('item?.song?._id: ' + (item != null ? (_ref = item.song) != null ? _ref._id : void 0 : void 0));
          if ((item != null ? (_ref1 = item.song) != null ? _ref1._id : void 0 : void 0) === id) {
            continue;
          }
          ids.push(item.song._id);
        }
        console.log('ids: ' + JSON.stringify(ids));
        return this.saveSongs(ids);
      },
      saveSongs: function(ids) {
        var updates,
          _this = this;
        updates = {
          songs: ids
        };
        return $.ajax({
          type: 'PUT',
          url: '/api/classrooms/' + this.get('id'),
          data: updates,
          success: function() {
            console.log('success save');
            return _this.refreshClassroom();
          },
          error: function(err) {
            return console.log('err:' + err.responseText);
          }
        });
      },
      saveClassroom: function(name) {
        var updates,
          _this = this;
        updates = {
          name: name
        };
        return $.ajax({
          type: 'PUT',
          url: '/api/classrooms/' + this.get('id'),
          data: updates,
          success: function() {
            console.log('Success!');
            return _this.refreshClassroom();
          },
          error: function(err) {
            return console.log('Error: ' + err.responseText);
          }
        });
      },
      searchSongs: function(query, callback) {
        var data,
          _this = this;
        if (query.trim().length < 1) {
          this.songSearchListModel.set({
            rawData: []
          });
          if (typeof callback === "function") {
            callback();
          }
          return;
        }
        data = {
          queryString: query,
          language: this.get('data').language
        };
        return $.ajax({
          type: 'GET',
          url: '/api/songs/search',
          data: data,
          dataType: 'json',
          success: function(res) {
            _this.songSearchListModel.set({
              rawData: res
            });
            return typeof callback === "function" ? callback() : void 0;
          },
          error: function(err) {
            console.log('Error: ' + err.responseText);
            return typeof callback === "function" ? callback() : void 0;
          }
        });
      },
      clearSongSearch: function() {
        return this.songSearchListModel.set({
          rawData: {}
        });
      },
      deleteClassroom: function(classroom) {
        var _this = this;
        return $.ajax({
          type: 'DELETE',
          url: '/api/classrooms/' + classroom.classroomId,
          success: function(res) {
            return _this.getClassrooms();
          },
          error: function(err) {
            return console.log('Error: ' + err.responseText);
          }
        });
      }
    });
    return EditClassroomModel;
  });

}).call(this);

/*
//@ sourceMappingURL=edit-classroom-model.js.map
*/