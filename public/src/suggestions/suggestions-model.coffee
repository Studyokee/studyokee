define [
  'backbone'
], (Backbone) ->
  SuggestionsModel = Backbone.Model.extend(
    defaults:
      enableLogging: false

    initialize: () ->
      this.updateSuggestions()

    updateSuggestions: () ->
      fromLanguage = this.get('settings').get('fromLanguage')
      toLanguage = this.get('settings').get('toLanguage')
      if this.get('enableLogging')
        console.log('SUGGESTIONS: retrieve suggestions fromLanguage: ' + fromLanguage + ', toLanguage: ' + toLanguage)
      
      this.set(
        data: []
        isLoading: true
      )

      getSuggestionsRequest = (suggestions) =>
        selectedItem = null
        if suggestions?.length > 0
          selectedItem = suggestions[0]
        
        this.set(
          data: suggestions
          isLoading: false
          selectedItem: selectedItem
        )

      dataProvider = this.get('dataProvider')
      dataProvider.getSuggestions(fromLanguage, toLanguage, getSuggestionsRequest)

  )

  return SuggestionsModel