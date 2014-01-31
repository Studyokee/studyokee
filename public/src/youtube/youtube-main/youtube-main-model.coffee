define [
  'songs.data.provider',
  'youtube.player.model',
  'subtitles.scroller.model',
  'backbone'
], (SongsDataProvider, YoutubePlayerModel, SubtitlesScrollerModel, Backbone) ->
  YoutubeMainModel = Backbone.Model.extend(

    initialize: () ->
      this.dataProvider = new SongsDataProvider(this.get('settings'))
      this.youtubePlayerModel = new YoutubePlayerModel(
        settings: this.get('settings')
      )

      this.subtitlesScrollerModel = new SubtitlesScrollerModel()

      this.youtubePlayerModel.on('play', (ts) =>
        this.subtitlesScrollerModel.play(ts)
      )
      this.youtubePlayerModel.on('pause', () =>
        this.subtitlesScrollerModel.pause()
      )

      this.on('changeSong', (song) =>
        this.youtubePlayerModel.set(
          currentSong: song
        )
        this.getSubtitles(song.song)
      )

    getSubtitles: (song) ->
      this.subtitlesScrollerModel.set(
        isLoading: true
      )

      if not song?
        this.subtitlesScrollerModel.set(
          isLoading: false
          subtitles: []
          translation: []
        )
        this.youtubePlayerModel.set(
          subtitles: []
        )
        return

      this.set(
        lastCallbackId: song._id
      )

      callback = (data) =>
        if this.get('lastCallbackId') is song._id
          this.subtitlesScrollerModel.set(
            isLoading: false
            subtitles: data.original
            translation: data.translation
          )
          this.youtubePlayerModel.set(
            subtitles: data.original
          )
      
      this.dataProvider.getSegments(song._id, this.get('settings').get('toLanguage'), callback)
  )

  return YoutubeMainModel