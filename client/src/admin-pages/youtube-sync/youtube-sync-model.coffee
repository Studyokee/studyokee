define [
  'backbone'
], (Backbone) ->
  YoutubeSyncModel = Backbone.Model.extend(
    defaults:
      subtitles: []
      i: 0
      playing: false

    initialize: () ->
      this.offset = 0
      this.quickPrev = false
      this.timer = null
      this.syncOffset = 500
      this.set(
        i: 0
        syncing: true
      )
      this.listenTo(this, 'change:playing', () =>
        if not this.get('playing')
          this.clearTimer()
      )
      this.listenTo(this, 'change:i', () =>
        console.log('i changed to: ' + this.get('i'))
      )
      this.listenTo(this, 'change:currentSong', () =>
        if this.get('ytPlayerReady')
          this.onChangeSong()
      )
      this.listenTo(this, 'change:syncing', () =>
        if not this.get('syncing')
          this.setTimer(this.getCurrentTime(), this.get('i'))
        else
          this.clearTimer()
      )

    reset: () ->
      this.pause()
      this.seek(0)
      this.quickPrev = false
      this.timer = null
      this.set(
        i: 0
        syncing: true
      )

    onStateChange: (event) ->
      state = event.data
      console.log('YOUTUBEEVENT!!!!: ' + state)
      console.log('\twith playing is: ' + this.get('playing'))
      console.log('\twith player state is: ' + this.ytPlayer.getPlayerState())

      #-1 (unstarted)
      #0 (ended)
      #1 (playing)
      #2 (paused)
      #3 (buffering)
      #5 (video cued)

      if state is 1
        this.trigger('play', this.getCurrentTime())
        this.set(
          playing: true
        )
        i = this.get('i')
        this.setTimer(this.getCurrentTime(), i)
      else if state is 0
        this.trigger('songFinished')
        this.set(
          playing: false
          i: 0
        )
      else if state is 3
        this.trigger('pause')
        this.set(
          playing: true
        )
      else
        this.trigger('pause')
        this.set(
          playing: false
        )

    play: () ->
      if this.ytPlayer?.playVideo?
        this.ytPlayer.playVideo()
        this.set(
          playing: true
        )

    pause: () ->
      if this.ytPlayer?.pauseVideo?
        this.ytPlayer.pauseVideo()
        this.set(
          playing: false
        )

    syncNext: () ->
      console.log('sync next')
      i = this.get('i') + 1
      subtitles = this.get('currentSong')?.subtitles
      if subtitles?[i]
        ts = Math.max(Math.round(this.getCurrentTime() - this.syncOffset), 0)
        this.addNewTime(i, ts)
        this.set(
          i: i
        )

    addNewTime: (i, ts) ->
      console.log('PLAYER: i set to : ' + ts)
      subtitles = this.get('currentSong')?.subtitles
      if subtitles?[i]
        #this.get('song').subtitles[i].ts = ts
        subtitles[i].ts = ts

        # Cleanse all future
        if subtitles.length > (i+1)
          start = i+1
          end = subtitles.length-1
          for j in [start..end]
            if subtitles[j].ts < subtitles[j-1].ts
              subtitles[j].ts = subtitles[j-1].ts

        this.trigger('updateSubtitles')

    next: () ->
      if this.get('syncing')
        this.syncNext()
        return

      console.log('normal next')
      i = this.get('i') + 1
      this.jumpTo(i)

    prev: () ->
      i = this.get('i')
      if this.isQuickPrev() or not this.get('playing')
        i = Math.max(i-1, 0)
      this.jumpTo(i)

    isQuickPrev: () ->
      clearTimeout(this.quickPrevTimeout)
      unset = () =>
        this.quickPrev = false
      this.quickPrevTimeout = setTimeout(unset, 1000)

      result = this.quickPrev
      this.quickPrev = true
      return result

    toStart: () ->
      this.jumpTo(0)

    jumpTo: (i) ->
      console.log('PLAYER: jump to: ' + i)
      subtitles = this.get('currentSong')?.subtitles
      if subtitles?[i]
        this.seek(subtitles[i].ts)
        this.set(
          i: i
        )

    onChangeSong: () ->
      currentSong = this.get('currentSong')
      if this.ytPlayer?.cueVideoById? and currentSong?
        this.ytPlayer.cueVideoById(currentSong.youtubeKey)
        if currentSong.youtubeOffset?
          this.offset = currentSong.youtubeOffset
        else
          this.offset = 0

    # INTERACTING WITH PLAYER, USE OFFSET
    getCurrentTime: () ->
      if this.ytPlayer?
        return (this.ytPlayer.getCurrentTime() * 1000) - this.offset
      return 0

    getDuration: () ->
      if this.ytPlayer? and this.ytPlayer.getDuration?
        return this.ytPlayer.getDuration()
      return 0

    getCurrentPercentageComplete: () ->
      if this.ytPlayer? and this.ytPlayer.getDuration?
        duration = this.ytPlayer.getDuration()
        if duration? > 0
          if this.get('playing')
            return this.ytPlayer.getCurrentTime() * 100/duration
          else
            subtitles = this.get('currentSong')?.subtitles
            if subtitles?.length > 0
              time = this.get('currentSong')?.subtitles[this.get('i')].ts / 1000
              return time*100/duration
      return 0
      
    seek: (trackPosition) ->
      console.log('PLAYER: seek: ' + (trackPosition + this.offset))
      if this.ytPlayer?.seekTo?
        this.ytPlayer.seekTo((trackPosition + this.offset)/1000, true)

    
    setTimer: (ts, currentIndex) ->
      this.clearTimer()
      this.set(
        i: currentIndex
      )

      if not this.get('playing')
        console.log('Don\'t set time, currently not playing?')
        return
      if this.get('syncing')
        console.log('Don\'t set time, currently syncing')
        return
      console.log('setTimer:currentIndex: ' + currentIndex)

      nextIndex = this.get('i') + 1
      subtitles = this.get('currentSong')?.subtitles
      if subtitles?[nextIndex]?
        nextTs = subtitles[nextIndex].ts
        diff = nextTs - ts

        console.log('PLAYER: nextTs: ' + nextTs)
        console.log('PLAYER: ts: ' + ts)
        console.log('PLAYER: Set timeout for: ' + diff)

        next = () =>
          this.setTimer(nextTs, nextIndex)
        this.timer = setTimeout(next, diff)

    clearTimer: () ->
      clearTimeout(this.timer)

    getPosition: (ts) ->
      subtitles = this.get('currentSong')?.subtitles
      if not ts? or not subtitles? or subtitles.length is 0
        return null

      i = 0
      while (i <= subtitles.length - 1) and subtitles[i].ts <= ts
        i++

      position = Math.max(i-1, 0)
      console.log('PLAYER: position: ' + position)
      return position

    splice: (i, toRemove, text) ->
      subtitles = this.get('currentSong')?.subtitles
      if subtitles
        ts = 0
        if i > 0
          ts = subtitles[i-1].ts

        if toRemove > 0
          ts = subtitles[i].ts

        item =
          text: text
          ts: ts
        subtitles.splice(i, toRemove, item)
        this.trigger('updateSubtitles')

    removeLine: (i) ->
      subtitles = this.get('currentSong')?.subtitles
      if subtitles?[i]?
        subtitles.splice(i, 1)
        this.trigger('updateSubtitles')
  )

  return YoutubeSyncModel