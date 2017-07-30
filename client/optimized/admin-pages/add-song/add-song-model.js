(function() {
  define(['backbone', 'music.search'], function(Backbone, MusicSearch) {
    var AddSongModel;
    AddSongModel = Backbone.Model.extend({
      defaults: {
        showAC: false
      },
      initialize: function() {
        return this.musicSearch = new MusicSearch();
      },
      search: function(query) {
        var _this = this;
        this.set({
          songs: [],
          isLoading: true,
          showAC: true
        });
        return this.musicSearch.search(query, function(suggestions) {
          return _this.set({
            songs: suggestions,
            isLoading: false
          });
        });
      }
    });
    return AddSongModel;
  });

}).call(this);

/*
//@ sourceMappingURL=add-song-model.js.map
*/