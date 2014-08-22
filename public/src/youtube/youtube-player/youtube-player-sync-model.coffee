define [
  'backbone'
], (Backbone) ->
  YoutubePlayerSyncModel = Backbone.Model.extend(
    default:
      subtitles: []
      i: 0

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

    onStateChange: (event) ->

    play: () ->
      if this.ytPlayer?.playVideo?
        this.ytPlayer.playVideo()

    pause: () ->
      if this.ytPlayer?.pauseVideo?
        this.ytPlayer.pauseVideo()

    next: () ->
      if this.ytPlayer?
        i = this.get('i') + 1
        currentTime = this.getCurrentTime()
        this.get('currentSong').subtitles[i].ts = currentTime
        this.set(
          i: i
        )
        console.log('PLAYER: set segment start to: ' + currentTime)

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
      
    seek: (trackPosition) ->
      console.log('PLAYER: seek: ' + (trackPosition + this.offset))
      if this.ytPlayer?.seekTo?
        this.ytPlayer.seekTo((trackPosition + this.offset)/1000, true)

  )

  return YoutubePlayerSyncModel