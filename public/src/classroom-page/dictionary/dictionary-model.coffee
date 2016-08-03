define [
  'backbone'
], (Backbone) ->
  
  DictionaryModel = Backbone.Model.extend(
    defaults:
      dictionaryResult: null
      isLoading: false

    initialize: () ->
      this.listenTo(this, 'change:query', () =>
        query = this.get('query')
        this.set(
          dictionaryResult: null
          lookup: query
        )

        this.lookup(query)
      )

    lookup: (query) ->
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      this.set(
        isLoading: true
      )
      $.ajax(
        type: 'GET'
        dataType: 'json'
        url: '/api/dictionary/' + fromLanguage + '/' + toLanguage + '?word=' + query
        success: (result) =>
          this.set(
            dictionaryResult: result
            isLoading: false
          )
        error: (error) =>
          this.set(
            isLoading: false
          )

          console.log('Error looking up word')
      )

  )

  return DictionaryModel