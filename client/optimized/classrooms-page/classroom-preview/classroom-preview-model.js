(function() {
  define(['backbone', 'media.item.list.model'], function(Backbone, MediaItemListModel) {
    var ClassroomPreviewModel;
    ClassroomPreviewModel = Backbone.Model.extend({
      initialize: function() {
        var _ref, _ref1;
        this.songListModel = new MediaItemListModel({
          rawData: this.get('songDisplayInfos')
        });
        if (((_ref = this.get('classroom')) != null ? (_ref1 = _ref.songs) != null ? _ref1.length : void 0 : void 0) > 0) {
          return this.getDisplayInfo(this.get('classroom').songs);
        } else {
          return this.songListModel.trigger('change');
        }
      },
      getDisplayInfo: function(ids) {
        var data,
          _this = this;
        data = {
          ids: ids
        };
        return $.ajax({
          type: 'GET',
          url: '/api/songs/display',
          data: data,
          dataType: 'json',
          success: function(res) {
            return _this.songListModel.set({
              rawData: res
            });
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      }
    });
    return ClassroomPreviewModel;
  });

}).call(this);

/*
//@ sourceMappingURL=classroom-preview-model.js.map
*/