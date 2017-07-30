(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var MediaItemView;
    MediaItemView = Backbone.View.extend({
      className: "mediaItem",
      initialize: function() {
        var _this = this;
        return this.listenTo(this.model, 'change', function() {
          console.log('change model');
          return _this.render();
        });
      },
      render: function() {
        var centerImage, _ref,
          _this = this;
        this.$el.html(Handlebars.templates['media-item'](this.model.toJSON()));
        if (!((_ref = this.model.get('data')) != null ? _ref.icon : void 0)) {
          this.$('.icon').toggle();
        }
        centerImage = function() {
          return _this.centerImage();
        };
        setTimeout(centerImage);
        return this;
      },
      centerImage: function() {
        var croppedImageWidth, extraWidth, fullImageWidth, img, leftMargin, outerWrapper;
        outerWrapper = this.$('.icon');
        img = this.$('.icon img');
        croppedImageWidth = outerWrapper.width();
        fullImageWidth = img.width();
        extraWidth = fullImageWidth - croppedImageWidth;
        leftMargin = Math.abs(extraWidth / 2);
        return img.css('margin-left', -leftMargin + 'px');
      }
    });
    return MediaItemView;
  });

}).call(this);

/*
//@ sourceMappingURL=media-item-view.js.map
*/