define [
  'youtube.translation.data.provider',
  'youtube.player.model',
  'subtitles.player.model',
  'backbone'
], (DataProvider, YoutubePlayerModel, SubtitlesPlayerModel, Backbone) ->
  YoutubeMainModel = Backbone.Model.extend(

    initialize: () ->
      dataProvider = new DataProvider(this.get('settings'))

      this.youtubePlayerModel = new YoutubePlayerModel(
        settings: this.get('settings')
      )

      this.subtitlesPlayerModel = new SubtitlesPlayerModel(
        dataProvider: dataProvider
        musicPlayer: this.youtubePlayerModel
        settings: this.get('settings')
      )

      this.on('changeSong', (song) =>
        this.subtitlesPlayerModel.set(
          currentSong: song
        )
        this.youtubePlayerModel.set(
          currentSong: song
        )
      )
  )

  return YoutubeMainModel