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

      this.listenTo(this, 'change:dictionaryResult', () =>
        word = this.get('dictionaryResult')
        if word?
          this.addToVocabulary(word)
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

    addToVocabulary: (word) ->
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage + '/add'
        data:
          word: word
        success: (res) =>
          this.trigger('vocabularyUpdate', res.words)
        error: (err) =>
          console.log('Error adding to vocabulary')
      )

  )

  return DictionaryModel