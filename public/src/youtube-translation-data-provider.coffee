define () ->
  class YoutubeTranslationDataProvider

    constructor: (@settings) ->
      @url = '/api'

    getSegments: (rdioKey, language, callback) ->
      subtitles = []
      original = []
      for i in [0..10]
        subtitles.push(
          text: 'test'
          ts: 0
        )
        original.push('test')
      song =
        original: subtitles
        translation: original
      callback(song)

    getSuggestions: (fromLanguage, toLanguage, callback) ->
      if @settings?.get('enableLogging')
        startTime = new Date().getTime()
        console.log('DATA PROVIDER: get video suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\'')
      $.ajax(
        type: 'GET'
        url: @url + '/suggestions/video?fromLanguage=' + fromLanguage + '&toLanguage=' + toLanguage
        success: (result) =>
          if @settings?.get('enableLogging')
            endTime = new Date().getTime()
            console.log('DATA PROVIDER: retrieved video suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\' in: ' + (endTime - startTime) + ' after: ' + (endTime - @settings.get('loadStartTime')) + ' since start, (' + endTime + ')')

          suggestions = []
          for video in result.items
            suggestion =
              id: video.id
              title: video.snippet.title
              description: video.snippet.description
              icon: video.snippet.thumbnails.medium.url
              
            suggestions.push(suggestion)

          callback(suggestions)

        error: (err) =>
          console.log('DATA PROVIDER: error retrieving suggestions: ' + err)
          callback([])
      )

  return YoutubeTranslationDataProvider