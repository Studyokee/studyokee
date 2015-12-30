define [
  'backbone'
], (Backbone) ->
  DictionaryModel = Backbone.Model.extend(
    defaults:
      word: null
      noResult: false
      inputClosed: true

    initialize: () ->
      this.listenTo(this, 'change:query', () =>
        this.lookup(this.get('fromLanguage'), this.get('toLanguage'), this.get('query'))
      )

    lookup: (fromLanguage, toLanguage, query) ->
      this.set(
        word: null
        noResult: false
        isLoading: true
        lookup: query
      )

      $.ajax(
        type: 'GET'
        dataType: 'json'
        url: '/api/dictionary/' + fromLanguage + '/' + toLanguage + '?word=' + query
        success: (result) =>
          word = {}
          if result?.length > 0
            word = result[0]

            this.set(
              word: word
              isLoading: false
            )
            this.addToVocabulary(word)
          else
            this.set(
              noResult: true
              isLoading: false
            )
        error: (error) =>
          console.log(error)
          this.set(
            isLoading: false
          )
      )

    addToVocabulary: (word) ->
      userId = this.get('settings').get('user').id

      if not userId
        return
        
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage + '/add'
        data:
          word: word
        success: (res) =>
          this.trigger('vocabularyUpdate', res.words)
        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return DictionaryModel