(function() {
  define(['backbone'], function(Backbone) {
    var MediaItemListModel;
    MediaItemListModel = Backbone.Model.extend({
      initialize: function() {
        var songListModel,
          _this = this;
        songListModel = new Backbone.Model();
        this.set({
          isLoading: true
        });
        return this.listenTo(this, 'change', function() {
          var data, icon, item, rawData, _i, _len, _ref, _ref1, _ref2, _ref3;
          rawData = _this.get('rawData');
          data = [];
          if (rawData) {
            for (_i = 0, _len = rawData.length; _i < _len; _i++) {
              item = rawData[_i];
              icon = '';
              if (item.videoSnippet != null) {
                icon = (_ref = item.videoSnippet.snippet) != null ? (_ref1 = _ref.thumbnails) != null ? _ref1.medium.url : void 0 : void 0;
              }
              item = {
                song: item.song,
                title: (_ref2 = item.song.metadata) != null ? _ref2.trackName : void 0,
                description: (_ref3 = item.song.metadata) != null ? _ref3.artist : void 0,
                icon: icon
              };
              data.push(item);
            }
          }
          return _this.set({
            isLoading: false,
            data: data
          });
        });
      }
    });
    return MediaItemListModel;
  });

}).call(this);

/*
//@ sourceMappingURL=media-item-list-model.js.map
*/