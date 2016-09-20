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
        settings: this.get('settings')
      )

      this.on('change:currentSong', () =>
        this.youtubePlayerModel.set(
          currentSong: this.get('currentSong')
        )

        this.subtitlesScrollerModel.set(
          currentSong: this.get('currentSong')
        )

        this.getSongData(this.get('currentSong')._id)
      )

      this.on('change:songData', () =>
        this.youtubePlayerModel.set(
          songData: this.get('songData')
        )
        this.subtitlesScrollerModel.set(
          songData: this.get('songData')
        )
      )

      this.on('change:vocabulary', () =>
        this.subtitlesScrollerModel.set(
          vocabulary: this.get('vocabulary')
        )
      )

      this.on('change:classroom', () =>
        displayInfos = this.get('displayInfos')
        this.menuModel.set(
          rawData: displayInfos
        )

        this.set(
          songDisplayInfos: displayInfos
        )

        title = this.getHash()
        currentSong = this.chooseSong(title)

        this.set(
          currentSong: currentSong
        )
      )

      this.youtubePlayerModel.on('change:i', () =>
        this.subtitlesScrollerModel.set(
          i: this.youtubePlayerModel.get('i')
        )
      )

      this.dictionaryModel.on('change:dictionaryResult', () =>
        word = this.dictionaryModel.get('dictionaryResult')
        if word?
          this.addToVocabulary(word)
      )

      this.getClassroom()
      this.getVocabulary()

    # Given a String
    # Returns the song matching the given title or the first song if no matches, or null if no songs
    chooseSong: (title) ->
      displayInfos = this.get('songDisplayInfos')
      if displayInfos?.length > 0
        songIndex = 0
        if title
          for info, index in displayInfos
            if info.song.metadata.trackName is title
              songIndex = index
              break
        return displayInfos[songIndex].song
    
      return null

    # Returns the hash in the url as a String, or null if no hash or empty hash
    getHash: () ->
      if document.location.hash.length > 0
        hash = document.location.hash.substring(1)
        if hash.length > 0
          return hash

      return null

    getClassroom: () ->
      $.ajax(
        type: 'GET'
        url: '/api/classrooms/' + this.get('id')
        dataType: 'json'
        success: (res) =>
          this.set(
            classroom: res.classroom
            displayInfos: res.displayInfos
          )
        error: (err) =>
          console.log('Error fetching classroom data')
      )

    getVocabulary: () ->
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'GET'
        url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage
        dataType: 'json'
        success: (res) =>
          this.set(
            vocabulary: res?.words
          )
        error: (err) =>
          console.log('Error getting user vocabulary')
      )

    # Retrieve the data for a song, but only update the model if it is the most recent
    # callback to protect when user switches quickly
    getSongData: (id, callback) ->
      if not id?
        return

      this.set(
        lastCallbackId: id
      )

      $.ajax(
        type: 'GET'
        url: '/api/songs/' + id
        dataType: 'json'
        success: (songData) =>
          if songData?._id is this.get('lastCallbackId')
            this.set(
              songData: songData
            )
        error: (err) =>
          console.log('Error fetching song data')
      )

    addToVocabulary: (word) ->
      if not word?
        return

      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage + '/add'
        data:
          word: word
        success: (res) =>
          this.set(
            vocabulary: res.words
          )
        error: (err) =>
          console.log('Error adding to vocabulary')
      )
  )

  return ClassroomModel