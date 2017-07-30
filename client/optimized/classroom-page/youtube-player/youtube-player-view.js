(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var YoutubePlayerView;
    YoutubePlayerView = Backbone.View.extend({
      className: 'video-player',
      initialize: function() {
        return this.playerId = 'ytPlayer';
      },
      render: function() {
        var postRender,
          _this = this;
        this.$el.html(Handlebars.templates['youtube-player'](this.model.toJSON()));
        postRender = function() {
          return _this.postRender();
        };
        setTimeout(postRender);
        return this;
      },
      postRender: function() {
        var onAPIReady, onReady, onStateChange,
          _this = this;
        onReady = function(event) {
          _this.model.ytPlayer = event.target;
          _this.model.ytPlayer.setPlaybackQuality('small');
          console.log('YT player ready');
          return _this.model.set({
            ytPlayerReady: true
          });
        };
        onStateChange = function(state) {
          var fn;
          fn = function() {
            return _this.model.onStateChange(state);
          };
          return setTimeout(fn);
        };
        onAPIReady = function() {
          var height, params, width, _ref;
          height = _this.$el.height();
          width = height * (4 / 3);
          params = {
            height: height,
            width: width,
            videoId: (_ref = _this.model.get('currentSong')) != null ? _ref.youtubeKey : void 0,
            playerVars: {
              modestbranding: 1,
              fs: 0,
              showInfo: 0,
              rel: 0,
              controls: 0
            },
            events: {
              'onReady': onReady,
              'onStateChange': onStateChange
            }
          };
          return new YT.Player(_this.playerId, params);
        };
        if (typeof YT === 'undefined' || typeof YT.Player === 'undefined') {
          window.onYouTubeIframeAPIReady = onAPIReady;
          return $.getScript('https://www.youtube.com/iframe_api');
        } else {
          return onAPIReady();
        }
      }
    });
    return YoutubePlayerView;
  });

}).call(this);

/*
//@ sourceMappingURL=youtube-player-view.js.map
*/