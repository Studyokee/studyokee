(function() {
  define(['subtitles.controls.view', 'youtube.sync.subtitles.view', 'backbone', 'handlebars', 'templates'], function(SubtitlesControlsView, YoutubeSubtitlesSyncView, Backbone, Handlebars) {
    var YoutubeSyncView;
    YoutubeSyncView = Backbone.View.extend({
      className: 'youtube-sync',
      initialize: function() {
        var _this = this;
        this.playerId = 'ytPlayerSync';
        this.subtitlesControlsView = new SubtitlesControlsView({
          model: this.model,
          allowToggleVideo: true
        });
        this.youtubeSubtitlesSyncView = new YoutubeSubtitlesSyncView({
          model: this.model
        });
        this.subtitlesControlsView.on('hideVideo', function() {
          return _this.$('.video-container').hide();
        });
        this.subtitlesControlsView.on('showVideo', function() {
          return _this.$('.video-container').show();
        });
        return this.listenTo(this.model, 'change:syncing', function() {
          return _this.renderSyncButton();
        });
      },
      render: function() {
        var postRender,
          _this = this;
        this.$el.html(Handlebars.templates['youtube-sync'](this.model.toJSON()));
        this.$('.controls-container').html(this.subtitlesControlsView.render().el);
        this.$('.subtitles-container').html(this.youtubeSubtitlesSyncView.render().el);
        this.$('.toggleSync').on('click', function() {
          if (_this.model.get('syncing')) {
            return _this.model.set({
              syncing: false
            });
          } else {
            return _this.model.set({
              syncing: true
            });
          }
        });
        this.renderSyncButton();
        postRender = function() {
          return _this.postRender();
        };
        setTimeout(postRender);
        return this;
      },
      renderSyncButton: function(syncing) {
        var toggleSync;
        toggleSync = this.$('.toggleSync');
        if (this.model.get('syncing')) {
          toggleSync.addClass('btn-primary');
          toggleSync.removeClass('btn-default');
          toggleSync.attr('title', 'Sync Off');
          return toggleSync.html('Sync Off');
        } else {
          toggleSync.removeClass('btn-primary');
          toggleSync.addClass('btn-default');
          toggleSync.attr('title', 'Sync On');
          return toggleSync.html('Sync On');
        }
      },
      calculateYTPlayerHeight: function() {
        var ytPlayerHeight, ytPlayerWidth;
        ytPlayerWidth = this.$('#' + this.playerId).width();
        ytPlayerHeight = ytPlayerWidth * 0.75;
        return this.$('#' + this.playerId).height(ytPlayerHeight + 'px');
      },
      postRender: function() {
        var onAPIReady, onReady, onStateChange,
          _this = this;
        onReady = function() {
          _this.model.set({
            ytPlayerReady: true
          });
          return _this.model.trigger('change:currentSong');
        };
        onStateChange = function(state) {
          var fn;
          fn = function() {
            return _this.model.onStateChange(state);
          };
          return setTimeout(fn);
        };
        onAPIReady = function() {
          var height, params, width;
          height = _this.$el.height();
          width = height * (4 / 3);
          params = {
            height: height,
            width: width,
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
          return _this.model.ytPlayer = new YT.Player(_this.playerId, params);
        };
        if (typeof YT === 'undefined' || typeof YT.Player === 'undefined') {
          window.onYouTubeIframeAPIReady = onAPIReady;
          return $.getScript('//www.youtube.com/iframe_api?noext');
        } else {
          return onAPIReady();
        }
      }
    });
    return YoutubeSyncView;
  });

}).call(this);

/*
//@ sourceMappingURL=youtube-sync-view.js.map
*/