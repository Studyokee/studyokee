define [
  'backbone'
], (Backbone) ->
  
  DictionaryModel = Backbone.Model.extend(
    initialize: () ->
      this.set(
        isLoading: false
        dictionaryResult: null
        isDE: this.get('settings').get('fromLanguage').language is 'de'
      )

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
      this.set(
        isLoading: true
      )

      # We are using an embedded German dictionary
      if fromLanguage is 'de'
        return

      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'GET'
        dataType: 'json'
        url: '/api/dictionary/' + fromLanguage + '/' + toLanguage + '?word=' + query
        success: (result) =>
          if result is null
            result = undefined
          this.set(
            dictionaryResult: result
            isLoading: false
          )
          this.trigger('update')

        error: (error) =>
          this.set(
            isLoading: false
          )

          console.log('Error looking up word')
      )

    addToVocabulary: (word, def) ->
      if not word?
        return

      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage + '/add'
        data:
          word: word
          def: def
        success: (res) =>
          this.trigger('wordAdded', res.words)
        error: (err) =>
          console.log('Error adding to vocabulary')
      )

  )

  return DictionaryModel