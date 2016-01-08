define [
  'songs.data.provider',
  'youtube.player.model',
  'subtitles.scroller.model',
  'backbone'
], (SongsDataProvider, YoutubePlayerModel, SubtitlesScrollerModel, Backbone) ->
  YoutubeMainModel = Backbone.Model.extend(
    default:
      subtitles: []
      translation: []
      resolutions: {}

    initialize: () ->
      this.dataProvider = new SongsDataProvider(this.get('settings'))
      this.youtubePlayerModel = new YoutubePlayerModel(
        settings: this.get('settings')
      )

      this.subtitlesScrollerModel = new SubtitlesScrollerModel(
        settings: this.get('settings')
      )
      this.listenTo(this.youtubePlayerModel, 'change:i', () =>
        this.subtitlesScrollerModel.set(
          i: this.youtubePlayerModel.get('i')
        )
      )

      this.on('vocabularyUpdate', (words) =>
        this.set(
          vocabulary: words
        )
      )

      this.on('changeSong', (song) =>
        this.getSubtitles(song)
        this.youtubePlayerModel.set(
          currentSong: song
        )
      )

      this.on('change:subtitles', () =>
        console.log('subtitles retrieved')
        this.processWords()
      )

      this.on('change:vocabulary', () =>
        console.log('vocabulary retrieved')
        this.processWords()
      )

      this.on('change:processedLines', () =>
        console.log('processedLines change, length: ' + this.get('processedLines').length)
        this.subtitlesScrollerModel.set(
          processedLines: this.get('processedLines')
        )
      )

      this.getVocabulary()

    getSubtitles: (song) ->
      this.subtitlesScrollerModel.set(
        isLoading: true
      )

      if not song?
        this.subtitlesScrollerModel.set(
          isLoading: false
        )
        this.youtubePlayerModel.set(
          subtitles: []
        )
        return

      this.set(
        lastCallbackId: song._id
      )

      callback = (song) =>
        if this.get('lastCallbackId') is song._id
          resolutions = {}
          if song?.resolutions?
            resolutionsArray = song.resolutions
            for resolution in resolutionsArray
              resolutions[resolution.word] = resolution.resolution
          console.log(JSON.stringify(resolutions, null, 4))
          
          this.subtitlesScrollerModel.set(
            isLoading: false
          )
          this.youtubePlayerModel.set(
            subtitles: song.subtitles
          )
          this.set(
            subtitles: song.subtitles
            translation: song.translations[0].data
            resolutions: resolutions
          )
      
      this.getSong(song._id, callback)

    getSong: (id, callback) ->
      if not id?
        return

      $.ajax(
        type: 'GET'
        url: '/api/songs/' + id
        dataType: 'json'
        success: (song) =>
          callback(song)
        error: (err) =>
          console.log('Error: ' + err)
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
          console.log('vocabulary retrieved')
          this.set(
            vocabulary: res?.words
          )
        error: (err) =>
          console.log('Error: ' + err)
      )

    processWords: (vocabulary) ->
      console.log('processWords')
      vocabulary = this.get('vocabulary')
      subtitles = this.get('subtitles')

      if not vocabulary or not subtitles
        return

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
              console.log('using: ' + lower + ' instead of ' + word)

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

      console.log('knownLyricsCount: ' + this.get('knownLyricsCount'))
      console.log('unknownLyricsCount: ' + this.get('unknownLyricsCount'))
      console.log('otherLyricsCount: ' + this.get('otherLyricsCount'))

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

  return YoutubeMainModel