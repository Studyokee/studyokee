define [
  'backbone'
], (Backbone) ->
  YoutubePlayerModel = Backbone.Model.extend(

    initialize: () ->
      this.listenTo(this, 'change:currentSong', () =>
        this.onChangeSong()
      )

    play: () ->
      if this.ytPlayer?
        this.ytPlayer.playVideo()

    pause: () ->
      if this.ytPlayer?
        this.ytPlayer.pauseVideo()

    seek: (trackPosition) ->
      if this.ytPlayer?
        this.ytPlayer.seekTo(trackPosition)

    onChangeSong: () ->
      if this.ytPlayer and this.get('currentSong')?
        this.ytPlayer.cueVideoById(this.get('currentSong').song.youtubeKey)
  )

  return YoutubePlayerModel