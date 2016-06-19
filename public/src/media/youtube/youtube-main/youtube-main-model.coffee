define [
  'dictionary.model',
  'songs.data.provider',
  'youtube.player.model',
  'subtitles.scroller.model',
  'backbone'
], (DictionaryModel, SongsDataProvider, YoutubePlayerModel, SubtitlesScrollerModel, Backbone) ->
  YoutubeMainModel = Backbone.Model.extend(
    
    initialize: () ->
      this.dataProvider = new SongsDataProvider(this.get('settings'))
      this.youtubePlayerModel = new YoutubePlayerModel(
        settings: this.get('settings')
      )
      this.subtitlesScrollerModel = new SubtitlesScrollerModel(
        settings: this.get('settings')
      )
      this.dictionaryModel = new DictionaryModel(
        fromLanguage: this.get('settings').get('fromLanguage').language
        toLanguage: this.get('settings').get('toLanguage').language
        settings: this.get('settings')
      )

      this.on('change:currentSong', () =>
        console.log('YoutubeMainModel:change current song')
        this.youtubePlayerModel.set(
          currentSong: this.get('currentSong')
        )
        this.subtitlesScrollerModel.set(
          currentSong: this.get('currentSong')
        )

        this.getSubtitles(this.get('currentSong'))
      )

      this.on('change:subtitles', () =>
        console.log('YoutubeMainModel:change subtitles')
        this.youtubePlayerModel.set(
          subtitles: this.get('subtitles')
        )
        this.subtitlesScrollerModel.set(
          subtitles: this.get('subtitles')
          translation: this.get('translation')
          resolutions: this.get('resolutions')
        )
      )

      this.on('change:vocabulary', () =>
        this.subtitlesScrollerModel.set(
          vocabulary: this.get('vocabulary')
        )
      )

      this.youtubePlayerModel.on('change:i', () =>
        this.subtitlesScrollerModel.set(
          i: this.youtubePlayerModel.get('i')
        )
      )

      this.dictionaryModel.on('vocabularyUpdate', (words) =>
        this.set(
          vocabulary: words
        )
      )

      this.getVocabulary()

    getSubtitles: (song) ->
      console.log('YoutubeMainModel: retrieved song data')
      if not song?
        this.youtubePlayerModel.set(
          subtitles: []
          processedLines: []
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
          
          console.log('YoutubeMainModel: update song data')
          this.set(
            subtitles: song.subtitles
            translation: song.translations[0].data
            resolutions: resolutions
          )
      
      this.getSong(song._id, callback)

    getVocabulary: () ->
      userId = this.get('settings').get('user').id
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'GET'
        url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage
        dataType: 'json'
        success: (res) =>
          this.set(
            vocabulary: res?.words
          )
        error: (err) =>
          console.log('Error: ' + err)
      )

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