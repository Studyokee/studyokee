(function() {
  define(['backbone'], function(Backbone) {
    var CreateSongModel;
    CreateSongModel = Backbone.Model.extend({
      saveSong: function(fields, success) {
        var _this = this;
        fields.language = this.get('defaultLanguage');
        return $.ajax({
          type: 'POST',
          url: '/api/songs/',
          dataType: 'json',
          data: fields,
          success: function(data, result) {
            if (result === 'success') {
              console.log('Success!');
              if (success != null) {
                return success(data[0]);
              }
            } else {
              return console.log('Error: ' + err);
            }
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      },
      getSongDetails: function(id, callback) {
        var _this = this;
        return $.ajax({
          type: 'GET',
          url: '/api/songs/youtube/' + id,
          dataType: 'json',
          success: function(result) {
            return callback(result);
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      }
    });
    return CreateSongModel;
  });

}).call(this);

/*
//@ sourceMappingURL=create-song-model.js.map
*/