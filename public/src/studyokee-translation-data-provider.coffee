define () ->
  class StudyokeeTranslationDataProvider

    constructor: (@settings) ->
      @lastSong = ''
      @url = '/api'

    getSegments: (rdioKey, language, callback) ->
      if @settings?.get('enableLogging')
        startTime = new Date().getTime()
        console.log('DATA PROVIDER: retrieving lyrics and translation for rdioKey: ' + rdioKey + ' with translation in: ' + language)

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

          if @settings?.get('enableLogging')
            endTime = new Date().getTime()
            console.log('DATA PROVIDER: time to load lyrics and translation in ' + (endTime - startTime) + ' after: ' + (endTime - @settings.get('loadStartTime')) + ' since start, (' + endTime + ')')
          callback(song)

      $.ajax(
        type: 'GET'
        url: @url + '/songs/' + rdioKey + '/translations/' + language
        success: (res) =>
          if @settings?.get('enableLogging')
            endTime = new Date().getTime()
            console.log('DATA PROVIDER: retrieved translation in: ' + (endTime - startTime) + ', (' + new Date().getTime() + ')')
          translation = res
          translationRetrieved = true
          onSuccess()
        error: (err) =>
          console.log('DATA PROVIDER: error retrieving translation: ' + err)
          translationRetrieved = true
          onSuccess()
      )

      $.ajax(
        type: 'GET'
        url: @url + '/songs/' + rdioKey + '/subtitles'
        success: (res) =>
          if @settings?.get('enableLogging')
            endTime = new Date().getTime()
            console.log('DATA PROVIDER: retrieved subtitles in: ' + (endTime - startTime) + ', (' + new Date().getTime() + ')')
          subtitles = res
          subtitlesRetrieved = true
          onSuccess()
        error: (err) =>
          console.log('DATA PROVIDER: error retrieving subtitles: ' + err)
          subtitlesRetrieved = true
          onSuccess()
      )

    getSuggestions: (fromLanguage, toLanguage, callback) ->
      if @settings?.get('enableLogging')
        startTime = new Date().getTime()
        console.log('DATA PROVIDER: get suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\'')
      $.ajax(
        type: 'GET'
        url: @url + '/songs/suggestions/' + fromLanguage + '/' + toLanguage
        success: (result) =>
          if @settings?.get('enableLogging')
            endTime = new Date().getTime()
            console.log('DATA PROVIDER: retrieved suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\' in: ' + (endTime - startTime) + ' after: ' + (endTime - @settings.get('loadStartTime')) + ' since start, (' + endTime + ')')

          callback(result)

        error: (err) =>
          console.log('DATA PROVIDER: error retrieving suggestions: ' + err)
          callback([])
      )

    saveSuggestions: (fromLanguage, toLanguage, rdioSuggestions) ->
      if @settings?.get('enableLogging')
        console.log('DATA PROVIDER: save suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\'')
      
      suggestions = []
      for rdioSuggestion in rdioSuggestions
        suggestions.push(rdioSuggestion.key)

      $.ajax(
        type: 'PUT'
        url: @url + '/songs/suggestions/' + fromLanguage + '/' + toLanguage
        data:
          suggestions: suggestions
        success: () ->
          console.log('success save')
        error: (err) ->
          console.log('err:' + err)
      )

    saveTranslation: (rdioKey, toLanguage, translation, callback) ->
      if @settings?.get('enableLogging')
        console.log('DATA PROVIDER: save translation for \'' + rdioKey + '\' in \'' + toLanguage + '\'')

      $.ajax(
        type: 'PUT'
        url: @url + '/songs/' + rdioKey + '/translations/' + toLanguage
        data:
          translation: translation
        success: () ->
          console.log('success save')
          callback()
        error: (err) ->
          console.log('err:' + err)
          callback()
      )

  return StudyokeeTranslationDataProvider