define [
  'backbone'
], (Backbone) ->
  SuggestionsModel = Backbone.Model.extend(
    defaults:
      enableLogging: false

    initialize: () ->
      this.listenTo(this, 'change:toLanguage', () =>
        this.updateSuggestions()
      )

      this.listenTo(this, 'change:fromLanguage', () =>
        this.updateSuggestions()
      )

      this.updateSuggestions()

    updateSuggestions: () ->
      fromLanguage = this.get('fromLanguage')
      toLanguage = this.get('toLanguage')
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