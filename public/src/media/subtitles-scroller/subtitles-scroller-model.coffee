define [
  'backbone'
], (Backbone) ->
  SubtitlesScrollerModel = Backbone.Model.extend(
    default:
      subtitles: []
      translation: []
      i: 0
      isLoading: true
      known: []
      unknown: []

    initialize: () ->
      this.getVocabulary()

      this.on('vocabularyUpdate', (words) =>
        sortedWords = this.sortWords(words)

        this.set(
          known: sortedWords.known
          unknown: sortedWords.unknown
          knownStems: sortedWords.knownStems
          unknownStems: sortedWords.unknownStems
        )
        this.trigger('highlightUpdate')
      )

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

            this.set(
              known: sortedWords.known
              unknown: sortedWords.unknown
              knownStems: sortedWords.knownStems
              unknownStems: sortedWords.unknownStems
            )
        error: (err) =>
          console.log('Error: ' + err)
      )

    sortWords: (words) ->
      known = {}
      unknown = {}
      knownStems = {}
      unknownStems = {}
      for word in words
        if word.known
          known[word.word] = 1
          knownStems[word.stem] = 1
        else
          unknown[word.word] = 1
          unknownStems[word.stem] = 1

      sortedWords =
        known: known
        unknown: unknown
        knownStems: knownStems
        unknownStems: unknownStems

      return sortedWords
  )

  return SubtitlesScrollerModel