define [
  'backbone',
  'handlebars',
  'youtube.sync.view',
  'jquery',
  'purl',
  'templates'
], (Backbone, Handlebars, SyncView, $) ->
  EditSongView = Backbone.View.extend(
    
    initialize: () ->
      this.syncView = new SyncView(
        model: this.model.syncModel
      )

      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      model = {}
      song = this.model.get('data')
      if song?
        formattedData = this.getFormattedData(song.subtitles, song.translations?[0]?.data)
        model.data = formattedData

      this.$el.html(Handlebars.templates['edit-song'](model))

      openModal = (word) ->
        $('.addResolution .resolveWord').html(word)
        $('.addResolution #metadata').val('')
        $('.addResolution').show()

      this.$('.notInDictionary').on('click', (event) ->
        word = $(this).html()
        openModal(word)
        event.preventDefault()
      )
      this.$('.inResolutions').on('click', (event) ->
        word = $(this).html()
        openModal(word)
        event.preventDefault()
      )
      $('.addResolution .saveResolution').on('click', (event) =>
        this.model.addResolution($('.addResolution .resolveWord').html(), $('.addResolution #resolution').val())
        $('.addResolution').hide()
        event.preventDefault()
      )
      $('.addResolution .addDefinition').on('click', (event) =>
        this.model.addToDictionary($('.addResolution #resolution').val())
        $('.addResolution').hide()
        event.preventDefault()
      )
      $('.addResolution .closeModal').on('click', (event) ->
        $('.addResolution').hide()
        event.preventDefault()
      )

      this.renderForm()
      this.renderModals()
      
      return this

    renderForm: () ->
      song = this.model.get('data')

      view = this
      this.$('.done').on('click', (event) ->
        window.history.back()
        event.preventDefault()
      )
      this.$('.save').on('click', (event) =>
        song.metadata.trackName = this.$('#trackName').val()
        song.metadata.artist = this.$('#artist').val()
        song.metadata.language = this.$('#language').val()
        song.youtubeKey = $.url(this.$('#youtubeKey').val()).param('v')
        this.model.saveSong(song)
        event.preventDefault()
      )

      this.$('#language').val(song?.metadata?.language)

      if song?.youtubeKey?
        this.$('#youtubeKey').val('http://www.youtube.com/watch?v=' + song.youtubeKey)

    renderModals: () ->
      this.$('.editSubtitles').on('click', (event) =>
        this.$('.editSubtitlesModal').show()
        this.$('.editSubtitlesModal .modal').show()
        event.preventDefault()
      )
      this.$('.closeEditSubtitlesModal').click(() =>
        this.$('.editSubtitlesModal').hide()
        event.preventDefault()
      )
      this.$('.saveSubtitles').click(() =>
        success = () =>
          this.$('.editSubtitlesModal').hide()

        this.model.saveSubtitles(this.$('#subtitlesEdit').val(), success)
        event.preventDefault()
      )

      this.$('.syncSubtitles').click(() =>
        this.$('.syncSubtitlesModal').show()
        this.$('.syncSubtitlesModal .modal').show()
        if this.$('.syncSubtitlesContainer').html().length is 0
          this.$('.syncSubtitlesContainer').html(this.syncView.render().el)
        
        event.preventDefault()
      )
      this.$('.closeSyncSubtitlesModal').click(() =>
        this.$('.syncSubtitlesModal').hide()
        this.model.syncModel.reset()

        # cleanup keyboard events
        window.subtitlesControlsTeardown?()

        event.preventDefault()
      )
      this.$('.saveSyncSubtitles').click(() =>
        success = () =>
          this.$('.syncSubtitlesModal').hide()
        this.model.syncModel.reset()

        this.model.saveSync(success)
        event.preventDefault()
      )

      this.$('.editTranslation').on('click', (event) =>
        this.$('.editTranslationModal').show()
        this.$('.editTranslationModal .modal').show()
        event.preventDefault()
      )
      this.$('.closeTranslationModal').click(() =>
        this.$('.editTranslationModal').hide()
        event.preventDefault()
      )
      this.$('.saveTranslation').click(() =>
        success = () =>
          this.$('.editTranslationModal').hide()

        this.model.saveTranslation(this.$('#translationEdit').val(), success)
        event.preventDefault()
      )

    createTextFromSubtitles: (subtitles) ->
      if not subtitles?
        return ''

      text = ''
      for line in subtitles
        text += line.text + '\n'
      return text

    createSubtitlesFromText: (text) ->
      lines = text.split('\n')
      subtitles = []
      for line in lines
        regexTs = /\[(.*)\]/
        tsMatch = line.match(regexTs)
        regexText = /\[.*\](.*)/
        textMatch = line.match(regexText)

        if tsMatch?.length is 2 and textMatch?.length is 2
          subtitle =
            text: textMatch[1]
            ts: tsMatch[1]
          subtitles.push(subtitle)

      return subtitles

    saveSong: () ->
      data = this.model.get('data')

      if data.translations?.length > 0
        data.translations[0].data = this.$('#translation').val().split('\n')

      song =
        rdioKey: this.$('#rdioKey').val()
        youtubeKey: this.$('#youtubeKey').val()
        youtubeOffset: this.$('#youtubeOffset').val()
        metadata:
          trackName: this.$('#trackName').val()
          artist: this.$('#artist').val()
          language: data.metadata.language
        subtitles: this.createSubtitlesFromText(this.$('#subtitles').val())
        translations: data.translations
        
      this.model.saveSong(song, () ->
        window.history.back())

    getFormattedData: (original, translation) ->
      data = []
      if not original?
        return data

      for i in [0..original.length]
        if not original[i]
          return data

        translationLine = ''
        if translation? and translation[i]?
          translationLine = translation[i]

        originalText = ''
        # get all words
        regex = /([ÀÈÌÒÙàèìòùÁÉÍÓÚÝáéíóúýÂÊÎÔÛâêîôûÃÑÕãñõÄËÏÖÜŸäëïöüŸçÇŒœßØøÅåÆæÞþÐð\w]+)/gi
        words = original[i].text.match(regex)
        if not words?
          words = []
          originalText = original[i].text
        else
          for word in words
            tag = this.getTag(word)
            originalText += '<a href="javaScript:void(0);" class="' + tag + '">' + word + '</a>&nbsp;'

        data.push(
          original: originalText
          translation: translationLine
          ts: original[i].ts
        )

      return data

    getTag: (word) ->
      dictionary = this.model.get('dictionary')
      stems = this.model.get('stems')

      if not dictionary? or not stems?
        return ''

      if this.isInDict(word)
        return 'inDictionary'

      resolutions = this.model.get('resolutions')
      if resolutions?
        userDefinedWord = resolutions[word.toLowerCase()]
        if userDefinedWord? and this.isInDict(userDefinedWord)
          return 'inResolutions'

      return 'notInDictionary'

    isInDict: (toCheck) ->
      dictionary = this.model.get('dictionary')
      stems = this.model.get('stems')

      if not dictionary? or not stems?
        return false

      lower = toCheck.toLowerCase()
      if dictionary[lower]?
        return true

      #stemming
      endings = ['a','o','as','os','es']
      stem = null
      if lower.length > 2
        for suffix in endings
          start = lower.indexOf(suffix, lower.length - suffix.length)
          if start isnt -1
            # has stem ending, strip down to stem and use that
            stem = lower.substr(0, start)
            break

        if stem? and stems[stem]?
          return true

      return false
  )

  return EditSongView