define [
  'rdio.player.model',
  'subtitles.scroller.model',
  'backbone'
], (RdioPlayerModel, SubtitlesPlayerModel, Backbone) ->
  RdioMainModel = Backbone.Model.extend(

    initialize: () ->
      this.rdioPlayerModel = new RdioPlayerModel(
        settings: this.get('settings')
      )

      this.subtitlesPlayerModel = new SubtitlesPlayerModel(
        musicPlayer: this.rdioPlayerModel
        settings: this.get('settings')
      )

      this.on('changeSong', (song) =>
        this.subtitlesPlayerModel.set(
          currentSong: song.song
        )
        this.rdioPlayerModel.set(
          currentSong: song
        )
      )
  )

  return RdioMainModel