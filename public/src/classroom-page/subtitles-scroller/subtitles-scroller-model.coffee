define [
  'backbone'
], (Backbone) ->
  SubtitlesScrollerModel = Backbone.Model.extend(

    initialize: () ->
      this.on('change:currentSong', () =>
        this.reset()
      )

      this.on('change:vocabulary', () =>
        this.updateFormattedData()
      )

      this.on('change:subtitles', () =>
        this.updateFormattedData()
      )

      this.on('change:songData', () =>
        this.parseAndUpdateSongData(this.get('songData'))
      )

    # Sets the model to the initial data for this object before loading data from the API
    reset: () ->
      this.set(
        translation: null
        resolutions: null
        subtitles: null
        processedLines: null
        i: 0
      )

    # Sets the model to the default data if something is wrong with the API data
    empty: () ->
      this.set(
        translation: []
        resolutions: {}
        subtitles: []
        processedLines: []
        i: 0
      )

    updateFormattedData: () ->
      this.updateVocabularyMaps()
      this.set(
        formattedData: this.formatData()
      )

    updateVocabularyMaps: () ->
      this.set(this.convertVocabularyArrayToMaps())

    parseAndUpdateSongData: (songData) ->
      if not songData?
        this.empty()

      # Convert api data to data structures we can use
      resolutions = {}
      if songData.resolutions?
        resolutionsArray = songData.resolutions
        for resolution in resolutionsArray
          resolutions[resolution.word] = resolution.resolution
      
      translation = []
      if songData.translations.length > 0
        translation = songData.translations[0].data

      this.set(
        subtitles: songData.subtitles
        translation: translation
        resolutions: resolutions
        i: 0
      )

    getLength: () ->
      lines = this.get('formattedData')
      if lines
        return lines.length
      else
        return null

    formatData: () ->
      processedSubtitles = this.processSubtitles()
      subtitles = this.get('subtitles')
      translation = this.get('translation')

      if not processedSubtitles?.length > 0 or not processedSubtitles.length is subtitles.length or not processedSubtitles.length is translation.length
        return []

      formattedData = []
      for line, i in processedSubtitles
        subtitlesElements = ''
        for word in line
          subtitlesElements += '<a href="javaScript:void(0);" class="' + word.tag + '" data-lookup="' + word.lookup + '">' + word.word + '</a>&nbsp;'

        formattedData.push(
          original: subtitlesElements
          translation: translation[i]
          ts: subtitles[i].ts
        )

      return formattedData

    # Create an array of lines, which are arrays of word objects with a tag and lookup associated with each word.
    processSubtitles: () ->
      vocabulary = this.get('vocabulary')
      subtitles = this.get('subtitles')

      if not vocabulary or not subtitles or subtitles.length is 0
        return

      processedSubtitles = []

      for i in [0..subtitles.length-1]
        processedSubtitleLine = []
        subtitleWords = this.getWords(subtitles[i].text)

        if subtitleWords
          for word in subtitleWords
            resolvedWord = this.resolveWord(word)
            processedWord =
              word: word
              tag: this.getTag(resolvedWord)
              lookup: resolvedWord
            processedSubtitleLine.push(processedWord)

        processedSubtitles.push(processedSubtitleLine)

      return processedSubtitles

    # Given a String
    # Returns the resolution for that String in the resolutions map or the String if none
    resolveWord: (word) ->
      resolutions = this.get('resolutions')
      lower = word.toLowerCase()
      if resolutions[lower]
        lower = resolutions[lower].toLowerCase()

      return lower

    # Given a String
    # Returns the separate words in that String as an array. If no words, just return whole String in array of length one
    getWords: (line) ->
      regex = /([ÀÈÌÒÙàèìòùÁÉÍÓÚÝáéíóúýÂÊÎÔÛâêîôûÃÑÕãñõÄËÏÖÜŸäëïöüŸçÇŒœßØøÅåÆæÞþÐð\w]+)/gi
      words = line.match(regex)
      if not words?.length > 0
        return [line]

      return words

    # Creates the vocabulary maps necessary for lookups from the vocabulary array
    convertVocabularyArrayToMaps: () ->
      vocabulary = this.get('vocabulary')
      known = {}
      unknown = {}
      knownStems = {}
      unknownStems = {}
      if vocabulary?
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

    # Given a String
    # Returns 'known' if the word matches a known word or word stem, 'unknown' if it matches the same for unknown
    # and '' if it doesn't match anything
    getTag: (word) ->
      known = this.get('known')
      unknown = this.get('unknown')
      knownStems = this.get('knownStems')
      unknownStems = this.get('unknownStems')

      if known[word]?
        return 'known'
      else if unknown[word]?
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

        if stem? and knownStems[stem]?
          return 'known'
        else if stem? and unknownStems[stem]?
          return 'unknown'

      return ''
  )

  return SubtitlesScrollerModel