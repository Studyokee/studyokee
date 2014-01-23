define [
  'studyokee.translation.data.provider',
  'backbone'
], (DataProvider, Backbone) ->
  SuggestionsModel = Backbone.Model.extend(
    defaults:
      enableLogging: false

    initialize: () ->
      this.set(
        dataProvider: new DataProvider(this.get('settings'))
      )
      this.updateSuggestions()

    updateSuggestions: () ->
      fromLanguage = this.get('settings').get('fromLanguage')
      toLanguage = this.get('settings').get('toLanguage')
      if this.get('enableLogging')
        console.log('SUGGESTIONS: retrieve suggestions fromLanguage: ' + fromLanguage + ', toLanguage: ' + toLanguage)
      
      this.set(
        songs: []
        isLoading: true
      )

      getSuggestionsRequest = (suggestions) =>
        selectedSong = null
        if suggestions?.length > 0
          selectedSong = suggestions[0]

        this.set(
          songs: suggestions
          isLoading: false
          selectedSong: selectedSong
        )

      dataProvider = this.get('dataProvider')
      dataProvider.getSuggestions(fromLanguage, toLanguage, getSuggestionsRequest)

  )

  return SuggestionsModel