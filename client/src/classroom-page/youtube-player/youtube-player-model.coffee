define [
  'backbone'
], (Backbone) ->
  YoutubePlayerModel = Backbone.Model.extend(
    default:
      subtitles: null
      i: 0
      playing: false
      state: -1

    initialize: () ->
      this.on('change:currentSong', () =>
        this.cueSong()
        this.pause()
        this.reset()
      )

      this.on('change:songData', () =>
        songData = this.get('songData')
        if songData?
          this.set(
            subtitles: songData.subtitles
          )
      )

      this.on('change:playing', () =>
        if not this.get('playing')
          this.clearTimer()
      )

      this.offset = 0
      this.quickPrev = false
      this.timer = null

    reset: () ->
      this.set(
        i: 0
        playing: false
        state: -1
        subtitles: null
        songData: null
      )

    onStateChange: (event) ->
      state = event.data

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
          state: state
        )
        i = this.get('i')
        console.log('start playing:i ' + i)
        this.setTimer(this.getCurrentTime(), i)
      else if state is 0
        this.trigger('songFinished')
        this.set(
          playing: false
          state: state
          i: 0
        )
      else if state is 3
        this.trigger('pause')
        this.set(
          playing: true
          state: state
        )
      else
        this.trigger('pause')
        this.set(
          playing: false
          state: state
        )

    play: () ->
      console.log('PLAYER: play')
      if this.ytPlayer?.playVideo?
        this.ytPlayer.playVideo()
        this.set(
          playing: true
        )

    pause: () ->
      console.log('PLAYER: pause')
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
      console.log('PLAYER: next')
      i = this.get('i') + 1
      this.jumpTo(i)

    prev: () ->
      console.log('PLAYER: prev')
      i = this.get('i')
      if this.isQuickPrev() or not this.get('playing')
        i = Math.max(i-1, 0)
      this.jumpTo(i)

    jumpTo: (i) ->
      console.log('PLAYER: jump to: ' + i)
      subtitles = this.get('subtitles')
      if subtitles?[i]
        this.seek(subtitles[i].ts)
        this.set(
          i: i
        )

    # If the user hits previous quickly jump to previous line instead of beginning of line
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
        return

      nextIndex = this.get('i') + 1
      subtitles = this.get('subtitles')
      if subtitles?[nextIndex]?
        nextTs = subtitles[nextIndex].ts
        diff = nextTs - ts

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
      return position

  )

  return YoutubePlayerModel