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

      $.ajax(
        type: 'GET'
        dataType: 'json'
        url: '/api/dictionary/?fromLanguage=' + fromLanguage + '&toLanguage=' + toLanguage + '&query=' + query
        success: (result) =>

          bestTranslation = ''
          originalTerm = ''

          definitionsArray = []
          if result?.term0?.PrincipalTranslations
            bestTranslation = result.term0.PrincipalTranslations[0]?.FirstTranslation?.term
            originalTerm = result.term0.PrincipalTranslations[0]?.OriginalTerm
            definitions = result.term0.PrincipalTranslations
            i = 0
            while definitions[i]
              definitionsArray.push(definitions[i])
              i++

          usesArray = []
          if result?.original?.Compounds
            compounds = result.original.Compounds
            i = 0
            while compounds[i]
              usesArray.push(compounds[i])
              i++

          this.set(
            originalTerm: originalTerm
            bestTranslation: bestTranslation
            definitions: definitionsArray
            uses: usesArray
            isLoading: false
          )
        error: (err) =>
          this.set(
            isLoading: false
          )
      )

  )

  return DictionaryModel