define () ->
  class RdioTranslationDataProvider

    constructor: (@settings) ->
      @url = '/api'

    getSuggestions: (fromLanguage, toLanguage, callback) ->
      if @settings?.get('enableLogging')
        startTime = new Date().getTime()
        console.log('DATA PROVIDER: get suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\'')
      $.ajax(
        type: 'GET'
        url: @url + '/suggestions/rdio?fromLanguage=' + fromLanguage + '&toLanguage=' + toLanguage
        success: (result) =>
          if @settings?.get('enableLogging')
            endTime = new Date().getTime()
            console.log('DATA PROVIDER: retrieved suggestions from \'' + fromLanguage + '\' to \'' + toLanguage + '\' in: ' + (endTime - startTime) + ' after: ' + (endTime - @settings.get('loadStartTime')) + ' since start, (' + endTime + ')')

          suggestions = []
          for i in [0..result.songs.length-1]
            song = result.songs[i]
            rdioData = result.rdioSongs[i]
            suggestion =
              song: song
              title: rdioData.name
              description: rdioData.artist
              icon: rdioData.icon
              
            suggestions.push(suggestion)

          callback(suggestions)

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
        url: @url + '/suggestions/rdio?fromLanguage=' + fromLanguage + '&toLanguage=' + toLanguage
        data:
          suggestions: suggestions
        success: () ->
          console.log('success save')
        error: (err) ->
          console.log('err:' + err)
      )

  return RdioTranslationDataProvider