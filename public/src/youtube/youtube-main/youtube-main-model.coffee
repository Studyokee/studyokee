define [
  'songs.data.provider',
  'youtube.player.model',
  'youtube.player.sync.model',
  'subtitles.scroller.model',
  'backbone'
], (SongsDataProvider, YoutubePlayerModel, YoutubePlayerSyncModel, SubtitlesScrollerModel, Backbone) ->
  YoutubeMainModel = Backbone.Model.extend(

    initialize: () ->
      this.dataProvider = new SongsDataProvider(this.get('settings'))
      if this.get('editMode')
        this.youtubePlayerModel = new YoutubePlayerSyncModel(
          settings: this.get('settings')
        )
      else
        this.youtubePlayerModel = new YoutubePlayerModel(
          settings: this.get('settings')
        )

      this.subtitlesScrollerModel = new SubtitlesScrollerModel()
      this.listenTo(this.youtubePlayerModel, 'change:i', () =>
        this.subtitlesScrollerModel.set(
          i: this.youtubePlayerModel.get('i')
        )
      )

      this.on('changeSong', (song) =>
        this.getSubtitles(song)
        this.youtubePlayerModel.set(
          currentSong: song
        )
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
      
      this.dataProvider.getSegments(song._id, this.get('language'), callback)
  )

  return YoutubeMainModel