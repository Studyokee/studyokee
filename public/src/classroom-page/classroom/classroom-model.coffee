define [
  'media.item.list.model',
  'dictionary.model',
  'songs.data.provider',
  'youtube.player.model',
  'subtitles.scroller.model',
  'backbone'
], (MenuModel, DictionaryModel, SongsDataProvider, YoutubePlayerModel, SubtitlesScrollerModel, Backbone) ->
  ClassroomModel = Backbone.Model.extend(

    initialize: () ->
      this.dataProvider = new SongsDataProvider(this.get('settings'))

      this.menuModel = new MenuModel(
        settings: this.get('settings')
      )
      this.subtitlesScrollerModel = new SubtitlesScrollerModel(
        settings: this.get('settings')
      )
      this.youtubePlayerModel = new YoutubePlayerModel(
        settings: this.get('settings')
      )
      this.dictionaryModel = new DictionaryModel(
        fromLanguage: this.get('settings').get('fromLanguage').language
        toLanguage: this.get('settings').get('toLanguage').language
        settings: this.get('settings')
      )

      this.on('change:currentSong', () =>
        console.log('ClassroomModel:change current song')
        this.youtubePlayerModel.set(
          currentSong: this.get('currentSong')
        )
        this.subtitlesScrollerModel.set(
          i: 0
        )

        this.getSubtitles(this.get('currentSong'))
      )

      this.on('change:subtitles', () =>
        console.log('ClassroomModel:change subtitles')
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

      this.dictionaryModel.on('vocabularyUpdate', (words) =>
        this.set(
          vocabulary: words
        )
      )

      this.youtubePlayerModel.on('change:i', () =>
        this.subtitlesScrollerModel.set(
          i: this.youtubePlayerModel.get('i')
        )
      )

      this.getClassroom()
      this.getVocabulary()

    getClassroom: () ->
      $.ajax(
        type: 'GET'
        url: '/api/classrooms/' + this.get('id')
        dataType: 'json'
        success: (res) =>
          console.log('Classroom: retrieved classroom data')
          this.set(
            data: res.classroom
          )
          this.menuModel.set(
            rawData: res.displayInfos
          )
          if res.displayInfos?.length > 0
            console.log('Classroom: update current song')

            currentSongIndex = 0
            if (window.location.hash.length > 0)
              currentSongTitle = window.location.hash.substring(1)
              if currentSongTitle.length > 0
                for info, index in res.displayInfos
                  if info.song.metadata.trackName is currentSongTitle
                    currentSongIndex = index
                    console.log('Selecting song: ' + currentSongTitle)
                    break

            currentSong = res.displayInfos[currentSongIndex].song
            this.set(
              currentSong: currentSong
            )
        error: (err) =>
          console.log('Error: ' + err)
      )

    getSubtitles: (song) ->
      console.log('ClassroomModel: retrieved song data')
      this.youtubePlayerModel.set(
        subtitles: null
        processedLines: null
      )
      this.subtitlesScrollerModel.set(
        subtitles: null
        processedLines: null
      )

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
          
          console.log('ClassroomModel: update song data')
          translation = []
          if song.translations.length > 0
            translation = song.translations[0].data

          this.set(
            subtitles: song.subtitles
            translation: translation
            resolutions: resolutions
          )
      
      this.getSong(song._id, callback)

    getVocabulary: () ->
      userId = this.get('settings').get('user').id
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'GET'
        url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage
        dataType: 'json'
        success: (res) =>
          console.log('ClassroomModel: retrieved vocabulary')
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

  return ClassroomModel