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
        this.set(
          translationType: result.type
          isLoading: false
        )
        if result.type is 'mw'
          this.updateMW(result.result)
        else
          this.updateGoogle(result.result)
          

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

    updateMW: (result) ->
      if result?.length > 0
        if result[0].hw[0]['_']
          word = result[0].hw[0]['_']
        else
          word = result[0].hw[0]

        parsedResult = this.parseMWForVocab(result)
        if word? and parsedResult.definitions.length > 0
          this.set(
            definitions: parsedResult.definitions
            examples: parsedResult.examples
            originalTerm: word
          )

          this.addToVocabulary(word, parsedResult.definitions)
        return

      this.set(
        definitions: []
        examples: []
        originalTerm: ''
      )

    parseMWForVocab: (result) ->
      definitions = []
      examplesMap = {}
      for type in result
        if type.example
          for example in type.example
            examplesMap[example] = ''

        if type?.def?.length > 0 and type.def[0].dt?.length > 0
          for variant in type.def[0].dt
            variantOptions = []
            if variant['ref-link']
              for variantOption in variant['ref-link']
                if typeof variantOption is 'string'
                  variantOptions.push(variantOption)
            else
              if typeof variant is 'string'
                variantOptions.push(variant)
              #else if typeof variant['_'] is 'string'
              #  variantOptions.push(variant['_'])

            if variantOptions.length > 0
              definition =
                definition: variantOptions
                partOfSpeech: type.fl[0]
              if variant.vi
                definition.context = variant.vi[0]

              definitions.push(definition)

      parsedResult =
        definitions: definitions
        examples: Object.keys(examplesMap)

      return parsedResult


    updateGoogle: (result) ->
      translations = JSON.parse(result)?.data?.translations
      if translations?.length > 0
        translation = translations[0]

        this.set(
          translation: translation.translatedText
          originalTerm: translation.t
        )

    addToVocabulary: (wordOrPhrase, definition) ->
      userId = this.get('settings').get('user').id

      if not userId
        return
        
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      console.log('Save word: ' + wordOrPhrase)
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