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
      this.listenTo(this, 'change:currentSong', () =>
        this.pause()
        this.onChangeSong()
        this.set(
          i: 0
        )
      )

    play: () ->
      if this.ytPlayer?.playVideo?
        this.ytPlayer.playVideo()
        this.set(
          playing: true
        )

    onStateChange: (event) ->
      state = event.data
      console.log('PLAYER: onStateChange: ' + state)
      console.log('playing is: ' + this.get('playing'))
      console.log('player state is: ' + this.ytPlayer.getPlayerState())
      if state is 1
        this.trigger('play', this.getCurrentTime())
        this.set(
          playing: true
        )
      if state is 3
        this.trigger('pause')
        this.set(
          playing: true
        )
      else
        this.trigger('pause')
        this.set(
          playing: false
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
        this.set(
          i: i
        )
        this.seek(subtitles[i].ts)
        this.trigger('play', subtitles[i].ts)

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

    # INTERACTING WITH PLAYER, USE OFFSET
    getCurrentTime: () ->
      if this.ytPlayer?
        return (this.ytPlayer.getCurrentTime() * 1000) - this.offset
      return 0
      
    seek: (trackPosition) ->
      console.log('PLAYER: seek: ' + (trackPosition + this.offset))
      if this.ytPlayer?.seekTo?
        this.ytPlayer.seekTo((trackPosition + this.offset)/1000, true)

  )

  return YoutubePlayerModel