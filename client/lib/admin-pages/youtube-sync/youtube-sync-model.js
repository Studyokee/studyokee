(function() {
  define(['backbone'], function(Backbone) {
    var YoutubeSyncModel;
    YoutubeSyncModel = Backbone.Model.extend({
      defaults: {
        subtitles: [],
        i: 0,
        playing: false
      },
      initialize: function() {
        var _this = this;
        this.offset = 0;
        this.quickPrev = false;
        this.timer = null;
        this.syncOffset = 500;
        this.set({
          i: 0,
          syncing: true
        });
        this.listenTo(this, 'change:playing', function() {
          if (!_this.get('playing')) {
            return _this.clearTimer();
          }
        });
        this.listenTo(this, 'change:i', function() {
          return console.log('i changed to: ' + _this.get('i'));
        });
        this.listenTo(this, 'change:currentSong', function() {
          if (_this.get('ytPlayerReady')) {
            return _this.onChangeSong();
          }
        });
        return this.listenTo(this, 'change:syncing', function() {
          if (!_this.get('syncing')) {
            return _this.setTimer(_this.getCurrentTime(), _this.get('i'));
          } else {
            return _this.clearTimer();
          }
        });
      },
      reset: function() {
        this.pause();
        this.seek(0);
        this.quickPrev = false;
        this.timer = null;
        return this.set({
          i: 0,
          syncing: true
        });
      },
      onStateChange: function(event) {
        var i, state;
        state = event.data;
        console.log('YOUTUBEEVENT!!!!: ' + state);
        console.log('\twith playing is: ' + this.get('playing'));
        console.log('\twith player state is: ' + this.ytPlayer.getPlayerState());
        if (state === 1) {
          this.trigger('play', this.getCurrentTime());
          this.set({
            playing: true
          });
          i = this.get('i');
          return this.setTimer(this.getCurrentTime(), i);
        } else if (state === 0) {
          this.trigger('songFinished');
          return this.set({
            playing: false,
            i: 0
          });
        } else if (state === 3) {
          this.trigger('pause');
          return this.set({
            playing: true
          });
        } else {
          this.trigger('pause');
          return this.set({
            playing: false
          });
        }
      },
      play: function() {
        var _ref;
        if (((_ref = this.ytPlayer) != null ? _ref.playVideo : void 0) != null) {
          this.ytPlayer.playVideo();
          return this.set({
            playing: true
          });
        }
      },
      pause: function() {
        var _ref;
        if (((_ref = this.ytPlayer) != null ? _ref.pauseVideo : void 0) != null) {
          this.ytPlayer.pauseVideo();
          return this.set({
            playing: false
          });
        }
      },
      syncNext: function() {
        var i, subtitles, ts, _ref;
        console.log('sync next');
        i = this.get('i') + 1;
        subtitles = (_ref = this.get('currentSong')) != null ? _ref.subtitles : void 0;
        if (subtitles != null ? subtitles[i] : void 0) {
          ts = Math.max(Math.round(this.getCurrentTime() - this.syncOffset), 0);
          this.addNewTime(i, ts);
          return this.set({
            i: i
          });
        }
      },
      addNewTime: function(i, ts) {
        var end, j, start, subtitles, _i, _ref;
        console.log('PLAYER: i set to : ' + ts);
        subtitles = (_ref = this.get('currentSong')) != null ? _ref.subtitles : void 0;
        if (subtitles != null ? subtitles[i] : void 0) {
          subtitles[i].ts = ts;
          if (subtitles.length > (i + 1)) {
            start = i + 1;
            end = subtitles.length - 1;
            for (j = _i = start; start <= end ? _i <= end : _i >= end; j = start <= end ? ++_i : --_i) {
              if (subtitles[j].ts < subtitles[j - 1].ts) {
                subtitles[j].ts = subtitles[j - 1].ts;
              }
            }
          }
          return this.trigger('updateSubtitles');
        }
      },
      next: function() {
        var i;
        if (this.get('syncing')) {
          this.syncNext();
          return;
        }
        console.log('normal next');
        i = this.get('i') + 1;
        return this.jumpTo(i);
      },
      prev: function() {
        var i;
        i = this.get('i');
        if (this.isQuickPrev() || !this.get('playing')) {
          i = Math.max(i - 1, 0);
        }
        return this.jumpTo(i);
      },
      isQuickPrev: function() {
        var result, unset,
          _this = this;
        clearTimeout(this.quickPrevTimeout);
        unset = function() {
          return _this.quickPrev = false;
        };
        this.quickPrevTimeout = setTimeout(unset, 1000);
        result = this.quickPrev;
        this.quickPrev = true;
        return result;
      },
      toStart: function() {
        return this.jumpTo(0);
      },
      jumpTo: function(i) {
        var subtitles, _ref;
        console.log('PLAYER: jump to: ' + i);
        subtitles = (_ref = this.get('currentSong')) != null ? _ref.subtitles : void 0;
        if (subtitles != null ? subtitles[i] : void 0) {
          this.seek(subtitles[i].ts);
          return this.set({
            i: i
          });
        }
      },
      onChangeSong: function() {
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
        if (this.ytPlayer != null) {
          return (this.ytPlayer.getCurrentTime() * 1000) - this.offset;
        }
        return 0;
      },
      getDuration: function() {
        if ((this.ytPlayer != null) && (this.ytPlayer.getDuration != null)) {
          return this.ytPlayer.getDuration();
        }
        return 0;
      },
      getCurrentPercentageComplete: function() {
        var duration, subtitles, time, _ref, _ref1;
        if ((this.ytPlayer != null) && (this.ytPlayer.getDuration != null)) {
          duration = this.ytPlayer.getDuration();
          if ((duration != null) > 0) {
            if (this.get('playing')) {
              return this.ytPlayer.getCurrentTime() * 100 / duration;
            } else {
              subtitles = (_ref = this.get('currentSong')) != null ? _ref.subtitles : void 0;
              if ((subtitles != null ? subtitles.length : void 0) > 0) {
                time = ((_ref1 = this.get('currentSong')) != null ? _ref1.subtitles[this.get('i')].ts : void 0) / 1000;
                return time * 100 / duration;
              }
            }
          }
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
        var diff, next, nextIndex, nextTs, subtitles, _ref,
          _this = this;
        this.clearTimer();
        this.set({
          i: currentIndex
        });
        if (!this.get('playing')) {
          console.log('Don\'t set time, currently not playing?');
          return;
        }
        if (this.get('syncing')) {
          console.log('Don\'t set time, currently syncing');
          return;
        }
        console.log('setTimer:currentIndex: ' + currentIndex);
        nextIndex = this.get('i') + 1;
        subtitles = (_ref = this.get('currentSong')) != null ? _ref.subtitles : void 0;
        if ((subtitles != null ? subtitles[nextIndex] : void 0) != null) {
          nextTs = subtitles[nextIndex].ts;
          diff = nextTs - ts;
          console.log('PLAYER: nextTs: ' + nextTs);
          console.log('PLAYER: ts: ' + ts);
          console.log('PLAYER: Set timeout for: ' + diff);
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
        var i, position, subtitles, _ref;
        subtitles = (_ref = this.get('currentSong')) != null ? _ref.subtitles : void 0;
        if ((ts == null) || (subtitles == null) || subtitles.length === 0) {
          return null;
        }
        i = 0;
        while ((i <= subtitles.length - 1) && subtitles[i].ts <= ts) {
          i++;
        }
        position = Math.max(i - 1, 0);
        console.log('PLAYER: position: ' + position);
        return position;
      },
      splice: function(i, toRemove, text) {
        var item, subtitles, ts, _ref;
        subtitles = (_ref = this.get('currentSong')) != null ? _ref.subtitles : void 0;
        if (subtitles) {
          ts = 0;
          if (i > 0) {
            ts = subtitles[i - 1].ts;
          }
          if (toRemove > 0) {
            ts = subtitles[i].ts;
          }
          item = {
            text: text,
            ts: ts
          };
          subtitles.splice(i, toRemove, item);
          return this.trigger('updateSubtitles');
        }
      },
      removeLine: function(i) {
        var subtitles, _ref;
        subtitles = (_ref = this.get('currentSong')) != null ? _ref.subtitles : void 0;
        if ((subtitles != null ? subtitles[i] : void 0) != null) {
          subtitles.splice(i, 1);
          return this.trigger('updateSubtitles');
        }
      }
    });
    return YoutubeSyncModel;
  });

}).call(this);

/*
//@ sourceMappingURL=youtube-sync-model.js.map
*/