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
        bestTranslation = ''
        originalTerm = ''
        definitionsArray = []
        usesArray = []

        if result?.term0?
          if result.term0.PrincipalTranslations
            bestTranslation = result.term0.PrincipalTranslations[0]?.FirstTranslation?.term
            originalTerm = result.term0.PrincipalTranslations[0]?.OriginalTerm
            definitions = result.term0.PrincipalTranslations
            i = 0
            while definitions[i]
              definitionsArray.push(definitions[i])
              i++

          if result?.original?.Compounds
            compounds = result.original.Compounds
            i = 0
            while compounds[i]
              usesArray.push(compounds[i])
              i++
        else if result?.data?.translations? and result.data.translations.length > 0
          definition =
            FirstTranslation: {term: result.data.translations[0].translatedText}
          definitionsArray.push(definition)

        this.set(
          originalTerm: originalTerm
          bestTranslation: bestTranslation
          definitions: definitionsArray
          uses: usesArray
          isLoading: false
        )

        definitionToSave =
          definitions: definitionsArray
          uses: usesArray
        this.addToVocabulary(originalTerm.term, definitionToSave)

      error = (err) =>
        this.set(
          isLoading: false
        )

      $.ajax(
        url: '//api.wordreference.com/3b126/json/' + fromLanguage + toLanguage + '/' + query
        type: 'POST'
        dataType: 'jsonp'
        success: success
        error: error
      )

      ###$.ajax(
        type: 'GET'
        dataType: 'json'
        url: '/api/dictionary/?fromLanguage=' + fromLanguage + '&toLanguage=' + toLanguage + '&query=' + query
        success: success
        error: error
      )###

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