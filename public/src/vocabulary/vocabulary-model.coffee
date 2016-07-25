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

      this.on('vocabularyUpdate', () =>
        this.vocabularySliderModel.trigger('vocabularyUpdate', this.get('unknown'))
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
          this.updateVocabulary(res)
        error: (err) =>
          console.log('Error: ' + err)
      )

    addNext: () ->
      userId = this.get('settings').get('user').id
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage + '/addNext'
        data:
          quantity: 50
        success: (res) =>
          console.log('Success!')
          this.updateVocabulary(res)
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
          word: word
        success: (res) =>
          console.log('Removed Word')
          this.updateVocabulary(res)
        error: (err) =>
          console.log('Error: ' + err)
      )

    updateVocabulary: (vocabulary) ->
      if vocabulary?.words?
        sortedWords = this.sortWords(vocabulary.words)

        this.set(
          known: sortedWords.known
          unknown: sortedWords.unknown
        )
        this.trigger('vocabularyUpdate', vocabulary.words)

    sortWords: (words) ->
      known = []
      unknown = []
      for word in words
        if word.known
          known.push(word)
        else
          unknown.push(word)
      console.log('known count: ' + known.length)
      console.log('unknown count: ' + unknown.length)

      sortedWords =
        known: known
        unknown: unknown

      return sortedWords

  )

  return VocabularyModel
