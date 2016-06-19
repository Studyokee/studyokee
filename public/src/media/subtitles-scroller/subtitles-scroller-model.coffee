define [
  'backbone'
], (Backbone) ->
  SubtitlesScrollerModel = Backbone.Model.extend(
    default:
      processedLines: []
      i: 0
      isLoading: true

    initialize: () ->
      this.on('change:currentSong', () =>
        # Reset
        this.set(
          processedLines: []
          i: 0
          isLoading: true
        )
      )

      this.on('change:subtitles', () =>
        this.processWords()
      )

      this.on('change:vocabulary', () =>
        this.processWords()
      )

    processWords: (vocabulary) ->
      vocabulary = this.get('vocabulary')
      subtitles = this.get('subtitles')
      if not vocabulary
        return
      if not subtitles
        return

      console.log('processWords')

      translation = this.get('translation')

      processedLines = []
      knownLyricsMap = {}
      unknownLyricsMap = {}
      otherLyricsMap = {}
      vocabularyMaps = this.createVocabularyMaps(vocabulary)
      resolutions = this.get('resolutions')

      for i in [0..subtitles.length-1]
        translationLine = ''
        if translation? and translation[i]?
          translationLine = translation[i]

        # get all words
        regex = /([ÀÈÌÒÙàèìòùÁÉÍÓÚÝáéíóúýÂÊÎÔÛâêîôûÃÑÕãñõÄËÏÖÜŸäëïöüŸçÇŒœßØøÅåÆæÞþÐð\w]+)/gi
        subtitleWords = subtitles[i].text.match(regex)

        processedLine =
          subtitles: [word:subtitles[i].text]
          translation: translationLine
          ts: subtitles[i].ts

        if subtitleWords
          processedSubtitles = []
          for word in subtitleWords
            # if we have a resolution for this word, use that instead of word
            lower = word.toLowerCase()

            if resolutions[lower]
              lower = resolutions[lower].toLowerCase()

            tag = this.getTag(lower, vocabularyMaps)

            if tag is 'known'
              knownLyricsMap[lower] = 1
            else if tag is 'unknown'
              unknownLyricsMap[lower] = 1
            else
              otherLyricsMap[lower] = 1
            
            processedWord =
              word: word
              tag: tag
              lookup: lower
            processedSubtitles.push(processedWord)

          processedLine.subtitles = processedSubtitles

        processedLines.push(processedLine)

      this.set(
        processedLines: processedLines
        knownLyricsCount: Object.keys(knownLyricsMap).length
        unknownLyricsCount: Object.keys(unknownLyricsMap).length
        otherLyricsCount: Object.keys(otherLyricsMap).length
      )

    createVocabularyMaps: (vocabulary) ->
      known = {}
      unknown = {}
      knownStems = {}
      unknownStems = {}
      for word in vocabulary
        if word.known
          known[word.word] = 1
          knownStems[word.stem] = 1
        else
          unknown[word.word] = 1
          unknownStems[word.stem] = 1

      maps =
        known: known
        unknown: unknown
        knownStems: knownStems
        unknownStems: unknownStems

      return maps

    getTag: (word, vocabularyMaps) ->
      if vocabularyMaps.known[word]?
        return 'known'
      else if vocabularyMaps.unknown[word]?
        return 'unknown'

      #stemming
      endings = ['a','o','as','os','es']
      stem = null
      if word.length > 2
        for suffix in endings
          start = word.indexOf(suffix, word.length - suffix.length)
          if start isnt -1
            # has stem ending, strip down to stem and use that
            stem = word.substr(0, start)
            break

        if stem? and vocabularyMaps.knownStems[stem]?
          return 'known'
        else if stem? and vocabularyMaps.unknownStems[stem]?
          return 'unknown'

      return ''
  )

  return SubtitlesScrollerModel