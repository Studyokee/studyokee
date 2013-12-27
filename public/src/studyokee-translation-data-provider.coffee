define () ->
  class StudyokeeTranslationDataProvider

    constructor: () ->
      @lastSong = ''
      @url = '/api'

    getSegments: (rdioKey, language, callback) ->
      console.log('DATA PROVIDER: retrieving subtitles for rdioKey: ' + rdioKey + ' with translation in: ' + language)
      start = new Date().getTime()

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

          diff = (new Date().getTime()) - start
          console.log('DATA PROVIDER: time to load lyrics and translation: ' + diff)
          callback(song)

      $.ajax(
        type: 'GET'
        url: @url + '/songs/' + rdioKey + '/translations/' + language
        success: (res) ->
          console.log('DATA PROVIDER: retrieved translation')
          translation = res
          translationRetrieved = true
          onSuccess()
      )

      $.ajax(
        type: 'GET'
        url: @url + '/songs/' + rdioKey + '/subtitles'
        success: (res) ->
          console.log('DATA PROVIDER: retrieved subtitles')
          subtitles = res
          subtitlesRetrieved = true
          onSuccess()
      )

    getSuggestions: (fromLanguage, toLanguage, callback) ->
      console.log('DATA PROVIDER: get suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\'')
      $.ajax(
        type: 'GET'
        url: @url + '/songs/suggestions/' + fromLanguage + '/' + toLanguage
        data:
          fromLanguage: fromLanguage
          toLanguage: toLanguage
        success: (result) ->
          console.log('DATA PROVIDER: retrieved suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\'')
          console.log(JSON.stringify(result))
          callback(result)
      )

  return StudyokeeTranslationDataProvider