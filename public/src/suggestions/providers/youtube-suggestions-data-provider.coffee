define () ->
  class YoutubeSuggestionsDataProvider

    constructor: (@settings) ->
      @url = '/api'

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
          for i in [0..result.songs.length-1]
            song = result.songs[i]
            icon = ''
            for video in result.videos
              if song.youtubeKey is video.id
                icon = video?.snippet?.thumbnails?.medium.url
            
            suggestion =
              song: song
              title: song.metadata?.trackName
              description: song.metadata?.artist
              icon: icon
              
            suggestions.push(suggestion)

          callback(suggestions)

        error: (err) =>
          console.log('DATA PROVIDER: error retrieving suggestions: ' + err)
          callback([])
      )

    saveSuggestions: (fromLanguage, toLanguage, ids, callback) ->
      if @settings?.get('enableLogging')
        console.log('DATA PROVIDER: save suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\'')
      
      $.ajax(
        type: 'PUT'
        url: @url + '/suggestions/video?fromLanguage=' + fromLanguage + '&toLanguage=' + toLanguage
        data:
          suggestions: ids
        success: () ->
          console.log('success save')
          if callback
            callback()
        error: (err) ->
          console.log('err:' + err)
          if callback
            callback()
      )

  return YoutubeSuggestionsDataProvider