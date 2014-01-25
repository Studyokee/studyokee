define [
  'rdio.translation.data.provider',
  'rdio.player.model',
  'subtitles.player.model',
  'backbone'
], (DataProvider, RdioPlayerModel, SubtitlesPlayerModel, Backbone) ->
  RdioMainModel = Backbone.Model.extend(

    initialize: () ->
      dataProvider = new DataProvider(this.get('settings'))

      this.rdioPlayerModel = new RdioPlayerModel(
        settings: this.get('settings')
      )

      this.subtitlesPlayerModel = new SubtitlesPlayerModel(
        dataProvider: dataProvider
        musicPlayer: this.rdioPlayerModel
        settings: this.get('settings')
      )

      this.on('changeSong', (song) =>
        this.subtitlesPlayerModel.set(
          currentSong: song
        )
        this.rdioPlayerModel.set(
          currentSong: song
        )
      )
  )

  return RdioMainModel