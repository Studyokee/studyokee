define [
  'backbone'
], (Backbone) ->
  VocabularyMapModel = Backbone.Model.extend(

    initialize: () ->
      this.on('vocabularyUpdate', (sorted) =>
        if not sorted?
          return

        knownMap = {}
        for item in sorted.known
          knownMap[item.word + '&' + item.part] = item

        unknownMap = {}
        for item in sorted.unknown
          unknownMap[item.word + '&' + item.part] = item

        this.set(
          'unknownMap': unknownMap
          'knownMap': knownMap
        )
      )

      this.getDictionary()

    getDictionary: () ->
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'GET'
        url: '/api/dictionary/' + fromLanguage + '/' + toLanguage + '/index'
        dataType: 'json'
        success: (words) =>
          if words?
            orderedDictionary = []
            overflow = []
            for item in words
              if parseInt(item.rank, 10) <= 5000
                orderedDictionary.push(item)
              else
                overflow.push(item)
            orderedDictionary = orderedDictionary.concat(overflow)

            this.set(
              orderedDictionary: orderedDictionary
            )
            this.trigger('change')
        error: (err) =>
          console.log('Error: ' + err)
      )
  )

  return VocabularyMapModel