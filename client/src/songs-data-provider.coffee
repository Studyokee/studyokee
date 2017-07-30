define () ->
  class SongsDataProvider

    constructor: (@settings) ->
      @lastSong = ''
      @url = '/api'

    getSegments: (_id, language, callback) ->
      console.log('DATA PROVIDER: getSegments')
          
      if @settings?.get('enableLogging')
        startTime = new Date().getTime()
        
      @lastSong = currentSong = _id

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

      console.log('DATA PROVIDER: get ' + @url + '/songs/' + _id + '/translations/' + language)
          
      $.ajax(
        type: 'GET'
        url: @url + '/songs/' + _id + '/translations/' + language
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
        url: @url + '/songs/' + _id + '/subtitles'
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

    saveTranslation: (_id, toLanguage, translation, callback) ->
      if @settings?.get('enableLogging')
        console.log('DATA PROVIDER: save translation for \'' + _id + '\' in \'' + toLanguage + '\'')

      $.ajax(
        type: 'PUT'
        url: @url + '/songs/' + _id + '/translations/' + toLanguage
        data:
          translation: translation
        success: () ->
          console.log('success save')
          callback()
        error: (err) ->
          console.log('err:' + err)
          callback()
      )

    saveSubtitles: (_id, subtitles, callback) ->
      if @settings?.get('enableLogging')
        console.log('DATA PROVIDER: save original for \'' + _id + '\'')

      $.ajax(
        type: 'PUT'
        url: @url + '/songs/' + _id + '/subtitles'
        data:
          subtitles: subtitles
        success: () ->
          console.log('success save')
          callback()
        error: (err) ->
          console.log('err:' + err)
          callback()
      )

  return SongsDataProvider