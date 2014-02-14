define [
  'backbone'
], (Backbone) ->
  YoutubePlayerModel = Backbone.Model.extend(
    default:
      subtitles: []
      i: 0
      playing: false

    initialize: () ->
      this.offset = 0
      this.quickPrev = false
      this.timer = null
      this.listenTo(this, 'change:currentSong', () =>
        this.pause()
        this.onChangeSong()
        this.set(
          i: 0
        )
      )
      this.listenTo(this, 'change:playing', () =>
        if this.get('playing')
          this.setTimerFromPlayer()
        else
          this.clearTimer()
      )

    onStateChange: (event) ->
      state = event.data
      console.log('PLAYER: onStateChange: ' + state)
      console.log('PLAYER: playing is: ' + this.get('playing'))
      console.log('PLAYER: player state is: ' + this.ytPlayer.getPlayerState())
      if state is 1
        this.trigger('play', this.getCurrentTime())
        this.set(
          playing: true
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

    next: () ->
      if this.ytPlayer?
        i = this.get('i') + 1
        this.seekIndex(i)

    prev: () ->
      if this.ytPlayer?
        i = this.get('i')
        if this.isQuickPrev() or not this.get('playing')
          i--

        this.seekIndex(i)

    seekIndex: (i) ->
      console.log('PLAYER: seek index: ' + i)
      subtitles = this.get('subtitles')
      if subtitles[i]
        this.seek(subtitles[i].ts)
        this.setTimer(subtitles[i].ts, i)

    isQuickPrev: () ->
      unset = () =>
        this.quickPrev = false
      setTimeout(unset, 2000)

      result = this.quickPrev
      this.quickPrev = true
      return result

    onChangeSong: () ->
      currentSong = this.get('currentSong')
      if this.ytPlayer?.cueVideoById? and currentSong?
        this.ytPlayer.cueVideoById(currentSong.song.youtubeKey)
        if currentSong.song.youtubeOffset?
          this.offset = currentSong.song.youtubeOffset
        else
          this.offset = 0

    # INTERACTING WITH PLAYER, USE OFFSET
    getCurrentTime: () ->
      if this.ytPlayer?
        return (this.ytPlayer.getCurrentTime() * 1000) - this.offset
      return 0
      
    seek: (trackPosition) ->
      console.log('PLAYER: seek: ' + (trackPosition + this.offset))
      if this.ytPlayer?.seekTo?
        this.ytPlayer.seekTo((trackPosition + this.offset)/1000, true)

    setTimerFromPlayer: () ->
      ts = this.getCurrentTime()
      currentIndex = this.getPosition(ts)
      this.setTimer(ts, currentIndex)

    setTimer: (ts, currentIndex) ->
      this.clearTimer()
      this.set(
        i: currentIndex
      )

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