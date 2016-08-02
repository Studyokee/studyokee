define [
  'backbone'
], (Backbone) ->
  
  DictionaryModel = Backbone.Model.extend(
    initialize: () ->
      this.listenTo(this, 'change:query', () =>
        this.set(
          word: null
          lookup: this.get('query')
        )

        fromLanguage = this.get('settings').get('fromLanguage').language
        toLanguage = this.get('settings').get('toLanguage').language

        this.lookup(fromLanguage, toLanguage, this.get('query'))
      )

      this.listenTo(this, 'change:word', () =>
        word = this.get('word')
        if word?
          this.addToVocabulary(word)
      )

    lookup: (fromLanguage, toLanguage, query) ->
      this.set(
        isLoading: true
      )
      $.ajax(
        type: 'GET'
        dataType: 'json'
        url: '/api/dictionary/' + fromLanguage + '/' + toLanguage + '?word=' + query
        success: (result) =>
          this.set(
            isLoading: false
          )

          if result?.length > 0
            this.set(
              word: result[0]
              noResult: false
            )
          else
            this.set(
              noResult: true
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