(function() {
  define(['backbone'], function(Backbone) {
    var YoutubePlayerModel;
    YoutubePlayerModel = Backbone.Model.extend({
      "default": {
        subtitles: null,
        i: 0,
        playing: false,
        state: -1
      },
      initialize: function() {
        var _this = this;
        this.on('change:currentSong', function() {
          _this.cueSong();
          _this.pause();
          return _this.reset();
        });
        this.on('change:songData', function() {
          var songData;
          songData = _this.get('songData');
          if (songData != null) {
            return _this.set({
              subtitles: songData.subtitles
            });
          }
        });
        this.on('change:playing', function() {
          if (!_this.get('playing')) {
            return _this.clearTimer();
          }
        });
        this.offset = 0;
        this.quickPrev = false;
        return this.timer = null;
      },
      reset: function() {
        return this.set({
          i: 0,
          playing: false,
          state: -1,
          subtitles: null,
          songData: null
        });
      },
      onStateChange: function(event) {
        var i, state;
        state = event.data;
        if (state === 1) {
          this.trigger('play', this.getCurrentTime());
          this.set({
            playing: true,
            state: state
          });
          i = this.get('i');
          console.log('start playing:i ' + i);
          return this.setTimer(this.getCurrentTime(), i);
        } else if (state === 0) {
          this.trigger('songFinished');
          return this.set({
            playing: false,
            state: state,
            i: 0
          });
        } else if (state === 3) {
          this.trigger('pause');
          return this.set({
            playing: true,
            state: state
          });
        } else {
          this.trigger('pause');
          return this.set({
            playing: false,
            state: state
          });
        }
      },
      play: function() {
        var _ref;
        console.log('PLAYER: play');
        if (((_ref = this.ytPlayer) != null ? _ref.playVideo : void 0) != null) {
          this.ytPlayer.playVideo();
          return this.set({
            playing: true
          });
        }
      },
      pause: function() {
        var _ref;
        console.log('PLAYER: pause');
        if (((_ref = this.ytPlayer) != null ? _ref.pauseVideo : void 0) != null) {
          this.ytPlayer.pauseVideo();
          return this.set({
            playing: false
          });
        }
      },
      toggle: function() {
        console.log(this.get('playing'));
        if (this.get('playing')) {
          return this.pause();
        } else {
          return this.play();
        }
      },
      next: function() {
        var i;
        console.log('PLAYER: next');
        i = this.get('i') + 1;
        return this.jumpTo(i);
      },
      prev: function() {
        var i;
        console.log('PLAYER: prev');
        i = this.get('i');
        if (this.isQuickPrev() || !this.get('playing')) {
          i = Math.max(i - 1, 0);
        }
        return this.jumpTo(i);
      },
      jumpTo: function(i) {
        var subtitles;
        console.log('PLAYER: jump to: ' + i);
        subtitles = this.get('subtitles');
        if (subtitles != null ? subtitles[i] : void 0) {
          this.seek(subtitles[i].ts);
          return this.set({
            i: i
          });
        }
      },
      isQuickPrev: function() {
        var result, unset,
          _this = this;
        clearTimeout(this.quickPrevTimeout);
        unset = function() {
          return _this.quickPrev = false;
        };
        this.quickPrevTimeout = setTimeout(unset, 500);
        result = this.quickPrev;
        this.quickPrev = true;
        return result;
      },
      cueSong: function() {
        var currentSong, _ref;
        currentSong = this.get('currentSong');
        if ((((_ref = this.ytPlayer) != null ? _ref.cueVideoById : void 0) != null) && (currentSong != null)) {
          this.ytPlayer.cueVideoById(currentSong.youtubeKey);
          if (currentSong.youtubeOffset != null) {
            return this.offset = currentSong.youtubeOffset;
          } else {
            return this.offset = 0;
          }
        }
      },
      getCurrentTime: function() {
        if ((this.ytPlayer != null) && (this.ytPlayer.getCurrentTime != null)) {
          return (this.ytPlayer.getCurrentTime() * 1000) - this.offset;
        }
        return 0;
      },
      seek: function(trackPosition) {
        var _ref;
        console.log('PLAYER: seek: ' + (trackPosition + this.offset));
        if (((_ref = this.ytPlayer) != null ? _ref.seekTo : void 0) != null) {
          return this.ytPlayer.seekTo((trackPosition + this.offset) / 1000, true);
        }
      },
      setTimer: function(ts, currentIndex) {
        var diff, next, nextIndex, nextTs, subtitles,
          _this = this;
        this.clearTimer();
        this.set({
          i: currentIndex
        });
        if (!this.get('playing')) {
          return;
        }
        nextIndex = this.get('i') + 1;
        subtitles = this.get('subtitles');
        if ((subtitles != null ? subtitles[nextIndex] : void 0) != null) {
          nextTs = subtitles[nextIndex].ts;
          diff = nextTs - ts;
          next = function() {
            return _this.setTimer(nextTs, nextIndex);
          };
          return this.timer = setTimeout(next, diff);
        }
      },
      clearTimer: function() {
        return clearTimeout(this.timer);
      },
      getPosition: function(ts) {
        var i, position, subtitles;
        subtitles = this.get('subtitles');
        if ((ts == null) || (subtitles == null) || subtitles.length === 0) {
          return null;
        }
        i = 0;
        while ((i <= subtitles.length - 1) && subtitles[i].ts <= ts) {
          i++;
        }
        position = Math.max(i - 1, 0);
        return position;
      }
    });
    return YoutubePlayerModel;
  });

}).call(this);

/*
//@ sourceMappingURL=youtube-player-model.js.map
*/