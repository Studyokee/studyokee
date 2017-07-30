(function() {
  define(['backbone'], function(Backbone) {
    var EditSongsModel;
    EditSongsModel = Backbone.Model.extend({
      initialize: function() {
        return this.getSongs();
      },
      getSongs: function() {
        var _this = this;
        return $.ajax({
          type: 'GET',
          url: '/api/songs',
          dataType: 'json',
          success: function(res) {
            return _this.set({
              data: res
            });
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      },
      deleteSong: function(song) {
        var _this = this;
        return $.ajax({
          type: 'DELETE',
          url: '/api/songs/' + song._id,
          success: function(res) {
            console.log('Success: ' + JSON.stringify(res, null, 4));
            return _this.getSongs();
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      }
    });
    return EditSongsModel;
  });

}).call(this);

/*
//@ sourceMappingURL=edit-songs-model.js.map
*/