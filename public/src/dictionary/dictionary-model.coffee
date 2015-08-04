define [
  'backbone'
], (Backbone) ->
  DictionaryModel = Backbone.Model.extend(

    initialize: () ->
      this.listenTo(this, 'change:query', () =>
        this.lookup(this.get('fromLanguage'), this.get('toLanguage'), this.get('query'))
      )

    lookup: (fromLanguage, toLanguage, query) ->
      this.set(
        lookup: ''
        isLoading: true
      )

      success = (result) =>
        translations = JSON.parse(result)?.data?.translations
        if translations?.length > 0
          translation = translations[0]
          originalTerm = query

          this.set(
            originalTerm: originalTerm
            translation: translation.translatedText
            isLoading: false
          )

          this.addToVocabulary(originalTerm, translation)

      error = (err) =>
        this.set(
          isLoading: false
        )

      ###$.ajax(
        url: '//api.wordreference.com/3b126/json/' + fromLanguage + toLanguage + '/' + unescape(encodeURIComponent(query))
        type: 'POST'
        dataType: 'jsonp'
        success: success
        error: error
      )###

      $.ajax(
        type: 'GET'
        dataType: 'json'
        url: '/api/dictionary/?fromLanguage=' + fromLanguage + '&toLanguage=' + toLanguage + '&query=' + query
        success: success
        error: error
      )

    addToVocabulary: (wordOrPhrase, definition) ->
      userId = this.get('settings').get('user').id

      if not userId
        return
        
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage + '/add'
        data:
          wordOrPhrase: wordOrPhrase
          definition: definition
        success: (res) =>
          console.log('Saved word')
        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return DictionaryModel