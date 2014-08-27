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
      this.savedPos = 0
      this.listenTo(this, 'change:currentSong', () =>
        if this.get('ytPlayerReady')
          this.pause()
          this.onChangeSong()
          this.set(
            i: 0
          )
          this.savedPos = 0
      )
      this.listenTo(this, 'change:playing', () =>
        if this.get('playing')
          i = this.get('i')
          console.log('start playing:savedPos ' + this.savedPos)
          console.log('start playing:i ' + i)
          this.setTimer(this.savedPos, i)
        else
          this.clearTimer()
          this.savedPos = this.getCurrentTime()
          console.log('paused: savedPos: ' + this.savedPos)
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

    next: () ->
      i = this.get('i') + 1
      if this.get('playing')
        this.jumpToWhilePlaying(i)
      else
        this.jumpToWhilePaused(i)

    prev: () ->
      i = this.get('i')
      if this.isQuickPrev() or not this.get('playing')
        i = Math.max(i-1, 0)
      if this.get('playing')
        this.jumpToWhilePlaying(i)
      else
        this.jumpToWhilePaused(i)

    toStart: () ->
      if this.get('playing')
        this.jumpToWhilePlaying(0)
      else
        this.jumpToWhilePaused(0)

    jumpToWhilePaused: (i) ->
      console.log('PLAYER: jump to while paused: ' + i)
      subtitles = this.get('subtitles')
      if subtitles?[i]
        this.savedPos = subtitles[i].ts
        this.set(
          i: i
        )
        this.seek(subtitles[i].ts)

    jumpToWhilePlaying: (i) ->
      console.log('PLAYER: jump to while playing: ' + i)
      subtitles = this.get('subtitles')
      if subtitles?[i]
        this.seek(subtitles[i].ts)
        this.setTimer(subtitles[i].ts, i)

    isQuickPrev: () ->
      clearTimeout(this.quickPrevTimeout)
      unset = () =>
        this.quickPrev = false
      this.quickPrevTimeout = setTimeout(unset, 500)

      result = this.quickPrev
      this.quickPrev = true
      return result

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