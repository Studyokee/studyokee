define [
  'backbone'
], (Backbone) ->
  VocabularyModel = Backbone.Model.extend(
    defaults:
      words: []
      index: 0

    initialize: () ->
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
            index = Math.random() * res.words.length
            this.set(
              words: this.getRandomOrder(res.words)
              index: 0
            )
        error: (err) =>
          console.log('Error: ' + err)
      )

    remove: (index) ->
      wordOrPhrase = this.get('words')[index].wordOrPhrase

      userId = this.get('settings').get('user').id
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage + '/remove'
        data:
          wordOrPhrase: wordOrPhrase
        success: (res) =>
          console.log('Removed Word')
          this.get('words').splice(index, 1)
          this.trigger('change')
          
          this.trigger('vocabularyUpdate', res.words)
        error: (err) =>
          console.log('Error: ' + err)
      )

    getRandomOrder: (array) ->
      order = []

      if array.length is 0
        return []

      for i in [0..array.length-1]
        order.push(i)

      order.sort(() ->
        return Math.random() - 0.5
      )

      newArray = []
      for i in order
        newArray.push(array[i])

      return newArray

  )

  return VocabularyModel
