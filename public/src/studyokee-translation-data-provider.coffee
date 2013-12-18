define () ->
  class StudyokeeTranslationDataProvider

    constructor: () ->
      @lastSong = ''
      @url = 'http://localhost:3000/api'

    getSegments: (rdioKey, language, callback) ->
      console.log('DATA PROVIDER: retrieving subtitles for rdioKey: ' + rdioKey + ' with translation in: ' + language)
      @lastSong = currentSong = rdioKey

      subtitlesRetrieved = false
      translationRetrieved = false
      subtitles = []
      translation = []

      onSuccess = () =>
        if currentSong is not @lastSong
          return
        
        if subtitlesRetrieved and translationRetrieved
          song =
            original: subtitles
            translation: translation
          callback(song)

      $.ajax(
        type: 'GET'
        url: @url + '/songs/' + rdioKey + '/translations/' + language
        success: (res) ->
          console.log('DATA PROVIDER: retrieved translation: ')
          console.log(JSON.stringify(res, null, 4))
          translation = res
          translationRetrieved = true
          onSuccess()
      )

      $.ajax(
        type: 'GET'
        url: @url + '/songs/' + rdioKey + '/subtitles'
        success: (res) ->
          console.log('DATA PROVIDER: retrieved subtitles: ')
          console.log(JSON.stringify(res, null, 4))
          subtitles = res
          subtitlesRetrieved = true
          onSuccess()
      )

    createSong: (rdioKey, originalLanguage, callback) ->
      console.log('DATA PROVIDER: create song in language: ' + originalLanguage + ' for rdio key: ' + rdioKey + ' :')

      song =
        metadata:
          language: originalLanguage

      $.ajax(
        type: 'PUT'
        url: @url + '/songs/' + rdioKey
        data: data: song
        success: () ->
          console.log('DATA PROVIDER: finished creating song')
          callback()
      )

    saveSubtitles: (rdioKey, subtitles, callback) ->
      console.log('DATA PROVIDER: save subtitles for rdio key: ' + rdioKey + ', new subtitles: ')
      console.log(subtitles)

      $.ajax(
        type: 'PUT'
        url: @url + '/songs/' + rdioKey + '/subtitles'
        data: data: subtitles
        success: () ->
          console.log('DATA PROVIDER: finished saving subtitles')
          callback()
      )

    saveTranslation: (rdioKey, language, lyrics, callback) ->
      console.log('DATA PROVIDER: save translation for \'' + language + '\', new lyrics: ')
      console.log(lyrics)

      $.ajax(
        type: 'PUT'
        url: @url + '/songs/' + rdioKey + '/translations/' + language
        data: data: lyrics
        success: () ->
          console.log('DATA PROVIDER: finished saving translation')
          callback()
      )

    getSuggestions: (fromLanguage, toLanguage, callback) ->
      console.log('DATA PROVIDER: get suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\'')
      $.ajax(
        type: 'GET'
        url: @url + '/songs'
        data:
          fromLanguage: fromLanguage
          toLanguage: toLanguage
        success: (result) ->
          suggestions = []
          _.each(result, (song) ->
            suggestion =
              id: song.rdioKey
            suggestions.push(suggestion)
          )

          console.log('DATA PROVIDER: retrieved suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\'')
          console.log(JSON.stringify(suggestions))
          callback(suggestions)
      )

  return StudyokeeTranslationDataProvider