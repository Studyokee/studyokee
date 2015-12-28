define [
  'backbone'
], (Backbone) ->
  HeaderModel = Backbone.Model.extend(
    defaults:
      vocabularyCount: 0
      classrooms: []

    initialize: () ->
      this.set(
        user: this.get('settings').get('user')
        fromLanguage: this.get('settings').get('fromLanguage').language
        toLanguage: this.get('settings').get('toLanguage').language
      )

      this.on('vocabularyUpdate', (words) ->
        this.set(
          vocabularyCount: this.getUnknownCount(words)
        )
      )

      this.getVocabularyCount()
      this.getClassrooms()
      

    getVocabularyCount: () ->
      userId = this.get('settings').get('user').id
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language

      if userId
        $.ajax(
          type: 'GET'
          url: '/api/vocabulary/' + userId + '/' + fromLanguage + '/' + toLanguage
          dataType: 'json'
          success: (res) =>
            if res?.words?
              this.set(
                vocabularyCount: this.getUnknownCount(res.words)
              )
          error: (err) =>
            console.log('Error: ' + err)
        )

    getUnknownCount: (words) ->
      unknownCount = 0
      for word in words
        if not word.known
          unknownCount++
      return unknownCount

    getClassrooms: () ->
      url = '/api/classrooms/page/' + this.get('settings').get('fromLanguage').language
      $.ajax(
        type: 'GET'
        url: url
        dataType: 'json'
        success: (res) =>
          this.set(
            classrooms: res.page
          )

        error: (err) =>
          console.log('Error: ' + err)
      )
  )

  return HeaderModel