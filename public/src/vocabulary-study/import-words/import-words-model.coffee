define [
  'backbone'
], (Backbone) ->
  ImportWordsModel = Backbone.Model.extend(
    defaults:
      wordsToAdd: []

    addWords: (wordAndDefinitions) ->
      words = Object.keys(wordAndDefinitions)

      userId = this.get('settings').get('user').id
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language

      console.log('words to add: ' + words)
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage + '/import'
        data:
          words: words
        success: (res) =>
          console.log('Success! for other words, not so much: ' + res.wordsNotInDictionary)

          if res?
            wordsToAdd = {}
            for word in res.wordsNotInDictionary
              wordsToAdd[word] = wordAndDefinitions[word]

            this.set(
              wordsToAdd: wordsToAdd
            )
            this.trigger('vocabularyUpdate', res.vocabulary)
        error: (err) =>
          console.log('Error: ' + err)
      )

    addWordToDictionary: (word) ->
      $.ajax(
        type: 'POST'
        url: '/api/dictionary/add'
        dataType: 'json'
        data:
          words: [word]
        success: (res) =>
          console.log('Added definitions: ' + JSON.stringify(word, null, 4))
          this.addToVocabulary(word)
        error: (err) =>
          console.log('Error: ' + err)
      )

    addToVocabulary: (word) ->
      userId = this.get('settings').get('user').id
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'PUT'
        url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage + '/add'
        data:
          word: word
        success: (res) =>
          this.trigger('vocabularyUpdate', res)
        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return ImportWordsModel