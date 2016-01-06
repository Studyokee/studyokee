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

      this.subtitlesScrollerModel = new SubtitlesScrollerModel(
        settings: this.get('settings')
      )
      this.listenTo(this.youtubePlayerModel, 'change:i', () =>
        this.subtitlesScrollerModel.set(
          i: this.youtubePlayerModel.get('i')
        )
      )

      this.on('vocabularyUpdate', (words) =>
        this.subtitlesScrollerModel.trigger('vocabularyUpdate', words)
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

      callback = (song) =>
        if this.get('lastCallbackId') is song._id
          resolutions = {}
          if song?.resolutions?
            resolutionsArray = song.resolutions
            for resolution in resolutionsArray
              resolutions[resolution.word] = resolution.resolution
          console.log(JSON.stringify(resolutions, null, 4))
          
          this.subtitlesScrollerModel.set(
            isLoading: false
            subtitles: song.subtitles
            translation: song.translation?[0]?.data
            resolutions: resolutions
          )
          this.youtubePlayerModel.set(
            subtitles: song.subtitles
          )
      
      this.getSong(song._id, callback)

    getSong: (id, callback) ->
      if not id?
        return

      $.ajax(
        type: 'GET'
        url: '/api/songs/' + id
        dataType: 'json'
        success: (song) =>
          callback(song)
        error: (err) =>
          console.log('Error: ' + err)
      )
  )

  return YoutubeMainModel