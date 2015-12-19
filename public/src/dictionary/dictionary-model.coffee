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
      if result.length > 0
        if result[0].hw[0]['_']
          word = result[0].hw[0]['_']
        else
          word = result[0].hw[0]
        this.set(
          translation: result
          originalTerm: word
        )

        this.addToVocabulary(word, this.parseMWForVocab(result))

    parseMWForVocab: (result) ->
      definitions = []
      for type in result
        for variant in type.def[0].dt
          definition =
            partOfSpeech: type.fl[0]

          variantOptions = []
          if variant['ref-link']
            for variantOption in variant['ref-link']
              variantOptions.push(variantOption)
          else
            variantOptions.push(variant)
          definition.definition = variantOptions

          if variant.vi
            definition.context = variant.vi[0]
          definitions.push(definition)

      return definitions


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