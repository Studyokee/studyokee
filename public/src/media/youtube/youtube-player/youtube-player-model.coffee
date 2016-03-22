define [
  'backbone'
], (Backbone) ->
  YoutubePlayerModel = Backbone.Model.extend(
    default:
      subtitles: []
      i: 0
      playing: false

    initialize: () ->
      this.on('change:currentSong', () =>
        # Reset
        this.cueSong()
        this.pause()
        this.set(
          subtitles: []
          i: 0
          playing: false
        )
      )

      this.on('cueSong', () =>
        this.cueSong()
      )

      this.offset = 0
      this.quickPrev = false
      this.timer = null

      this.listenTo(this, 'change:playing', () =>
        if not this.get('playing')
          this.clearTimer()
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
        console.log('start playing:i ' + i)
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

    toggle: () ->
      console.log(this.get('playing'))
      if this.get('playing')
        this.pause()
      else
        this.play()

    next: () ->
      i = this.get('i') + 1
      this.jumpTo(i)

    prev: () ->
      i = this.get('i')
      if this.isQuickPrev() or not this.get('playing')
        i = Math.max(i-1, 0)
      this.jumpTo(i)

    toStart: () ->
      this.jumpTo(0)

    jumpTo: (i) ->
      console.log('PLAYER: jump to: ' + i)
      subtitles = this.get('subtitles')
      if subtitles?[i]
        this.seek(subtitles[i].ts)
        this.set(
          i: i
        )

    isQuickPrev: () ->
      clearTimeout(this.quickPrevTimeout)
      unset = () =>
        this.quickPrev = false
      this.quickPrevTimeout = setTimeout(unset, 500)

      result = this.quickPrev
      this.quickPrev = true
      return result

    cueSong: () ->
      currentSong = this.get('currentSong')
      if this.ytPlayer?.cueVideoById? and currentSong?
        this.ytPlayer.cueVideoById(currentSong.youtubeKey)
        if currentSong.youtubeOffset?
          this.offset = currentSong.youtubeOffset
        else
          this.offset = 0

    # INTERACTING WITH PLAYER, USE OFFSET
    getCurrentTime: () ->
      if this.ytPlayer? and this.ytPlayer.getCurrentTime?
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
            subtitles = this.get('subtitles')
            if subtitles?.length > 0
              time = this.get('subtitles')[this.get('i')].ts / 1000
              return time*100/duration
      return 0
      
    seek: (trackPosition) ->
      console.log('PLAYER: seek: ' + (trackPosition + this.offset))
      if this.ytPlayer?.seekTo?
        this.ytPlayer.seekTo((trackPosition + this.offset)/1000, true)

    setTimer: (ts, currentIndex) ->
      console.log('setTimer:currentIndex: ' + currentIndex)
      this.clearTimer()
      this.set(
        i: currentIndex
      )

      if not this.get('playing')
        return

      nextIndex = this.get('i') + 1
      subtitles = this.get('subtitles')
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
      subtitles = this.get('subtitles')
      if not ts? or not subtitles? or subtitles.length is 0
        return null

      i = 0
      while (i <= subtitles.length - 1) and subtitles[i].ts <= ts
        i++

      position = Math.max(i-1, 0)
      console.log('PLAYER: position: ' + position)
      return position

  )

  return YoutubePlayerModel