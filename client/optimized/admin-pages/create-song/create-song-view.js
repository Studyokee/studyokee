(function() {
  define(['backbone', 'handlebars', 'jquery', 'purl', 'templates'], function(Backbone, Handlebars, $) {
    var CreateSongView;
    CreateSongView = Backbone.View.extend({
      className: "createSong",
      initialize: function() {
        var _this = this;
        return this.listenTo(this.model, 'change', function() {
          return _this.render();
        });
      },
      render: function() {
        var populateFields, view,
          _this = this;
        this.$el.html(Handlebars.templates['create-song']());
        view = this;
        this.$('.cancel').on('click', function(event) {
          view.trigger('cancel');
          return event.preventDefault();
        });
        this.$('.save').on('click', function(event) {
          var fields, success;
          fields = {
            trackName: _this.$('#trackName').val(),
            artist: _this.$('#artist').val(),
            youtubeKey: $.url(_this.$('#youtubeKey').val()).param('v')
          };
          success = function(savedSong) {
            return view.trigger('saveSuccess', savedSong);
          };
          _this.model.saveSong(fields, success);
          return event.preventDefault();
        });
        populateFields = function(rawTitle) {
          var artist, split, trackName;
          artist = '';
          trackName = '';
          if (rawTitle && rawTitle.indexOf) {
            split = rawTitle.indexOf('-');
            if (split >= 0) {
              artist = rawTitle.substr(0, split);
              trackName = rawTitle.substr(split + 1);
            } else {
              trackName = rawTitle;
            }
          }
          if (!_this.$('#artist').val()) {
            _this.$('#artist').val($.trim(artist));
          }
          if (!_this.$('#trackName').val()) {
            return _this.$('#trackName').val($.trim(trackName));
          }
        };
        this.$('#youtubeKey').on('keyup', function() {
          var id, url;
          url = _this.$('#youtubeKey').val();
          id = url.substr(url.indexOf('=') + 1);
          return _this.model.getSongDetails(id, populateFields);
        });
        return this;
      }
    });
    return CreateSongView;
  });

}).call(this);

/*
//@ sourceMappingURL=create-song-view.js.map
*/