define [
  'youtube.player.model',
  'subtitles.player.model',
  'backbone'
], (YoutubePlayerModel, SubtitlesPlayerModel, Backbone) ->
  YoutubeMainModel = Backbone.Model.extend(

    initialize: () ->
      this.youtubePlayerModel = new YoutubePlayerModel(
        settings: this.get('settings')
      )

      this.subtitlesPlayerModel = new SubtitlesPlayerModel(
        musicPlayer: this.youtubePlayerModel
        settings: this.get('settings')
      )

      this.on('changeSong', (song) =>
        this.subtitlesPlayerModel.set(
          currentSong: song.song
        )
        this.youtubePlayerModel.set(
          currentSong: song
        )
      )
  )

  return YoutubeMainModel