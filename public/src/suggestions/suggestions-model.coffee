define [
  'backbone'
], (Backbone) ->
  SuggestionsModel = Backbone.Model.extend(
    defaults:
      enableLogging: false

    initialize: () ->
      this.listenTo(this, 'change:songs', () =>
        if this.get('enableLogging')
          console.log('SUGGESTIONS: change suggestions')
        
        suggestions = this.get('songs')
        if suggestions.length > 0
          this.set(
            selectedSong: suggestions[0]
          )
        else
          this.set(
            selectedSong: null
          )
      )

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
        this.set(
          songs: suggestions
          isLoading: false
        )

      dataProvider = this.get('dataProvider')
      dataProvider.getSuggestions(fromLanguage, toLanguage, getSuggestionsRequest)

  )

  return SuggestionsModel