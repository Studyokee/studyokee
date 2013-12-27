define [
  'backbone'
], (Backbone) ->
  SuggestionsModel = Backbone.Model.extend(
    defaults:
      enableLogging: false

    initialize: () ->
      this.listenTo(this, 'change:suggestions', () =>
        if this.get('enableLogging')
          console.log('SUGGESTIONS: change suggestions')
        
        suggestions = this.get('suggestions')
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
      
      fn = (suggestions) =>
        this.set(
          suggestions: suggestions
        )

      dataProvider = this.get('dataProvider')
      suggestions = dataProvider.getSuggestions(fromLanguage, toLanguage, fn)

    getSuggestion: (key) ->
      suggestions = this.get('suggestions')
      for suggestion in suggestions
        if suggestion.key is key
          return suggestion
      return null
  )

  return SuggestionsModel