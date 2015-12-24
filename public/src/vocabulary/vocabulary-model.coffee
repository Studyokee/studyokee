define [
  'vocabulary.slider.model',
  'backbone'
], (VocabularySliderModel, Backbone) ->
  VocabularyModel = Backbone.Model.extend(
    defaults:
      known: []
      unknown: []

    initialize: () ->
      this.vocabularySliderModel = new VocabularySliderModel()

      this.vocabularySliderModel.on('removeWord', (word) =>
        this.remove(word)
      )

      this.getVocabulary()

    getVocabulary: () ->
      userId = this.get('settings').get('user').id
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'GET'
        url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage
        dataType: 'json'
        success: (res) =>
          if res?.words?
            sortedWords = this.sortWords(res.words)

            ###for i in [0..900]
              sortedWords.known.push({})
            for j in [0..600]
              sortedWords.unknown.push({})###

            this.set(
              known: sortedWords.known
              unknown: sortedWords.unknown
            )
            this.vocabularySliderModel.set(
              rawWords: sortedWords.unknown
            )
        error: (err) =>
          console.log('Error: ' + err)
      )

    remove: (word) ->
      userId = this.get('settings').get('user').id
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage + '/remove'
        data:
          wordOrPhrase: word
        success: (res) =>
          console.log('Removed Word')
          if res?.words?
            sortedWords = this.sortWords(res.words)

            this.set(
              known: sortedWords.known
              unknown: sortedWords.unknown
            )
            this.trigger('vocabularyUpdate', res.words)
        error: (err) =>
          console.log('Error: ' + err)
      )

    sortWords: (words) ->
      known = []
      unknown = []
      for word in words
        if word.known
          known.push(word)
        else
          unknown.push(word)

      sortedWords =
        known: known
        unknown: unknown

      return sortedWords

  )

  return VocabularyModel
