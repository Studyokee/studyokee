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
      song = this.model.get('data')
      model =
        data: song

      if song
        model.lyrics = this.formatData(song)

      this.$el.html(Handlebars.templates['edit-song'](model))

      song = this.model.get('data')

      this.$('.songDetails input').blur(() =>
        if not song.metadata
          song.metadata = {}
        song.metadata.trackName = this.$('#trackName').val()
        song.metadata.artist = this.$('#artist').val()
        song.youtubeKey = $.url(this.$('#youtubeKey').val()).param('v')
        this.model.saveSong(song)
      )

      that = this

      this.$('.editSubtitleLineLink').click(() ->
        $(this).find('.editSubtitleLine').removeClass('textInput')
      )
      this.$('.editSubtitleLine').blur(() ->
        parent = $(this).closest('tr')
        index = parent.attr('data-index')
        newVal = $.trim($(this).val())

        if that.model.get('data')?.subtitles[index]
          that.model.get('data')?.subtitles[index]?.text = newVal
        else
          that.model.get('data')?.subtitles[index] =
            text: newVal
            ts: 0

        $(this).addClass('textInput')

        that.model.saveSong(that.model.get('data'), () =>
          that.trigger('change')
        )
      )

      this.$('.editTranslationLineLink').click(() ->
        $(this).find('.editTranslationLine').removeClass('textInput')
      )
      this.$('.editTranslationLine').blur(() ->
        parent = $(this).closest('tr')
        index = parent.attr('data-index')
        newVal = $.trim($(this).val())

        that.model.get('data')?.translations[0]?.data?[index] = newVal

        $(this).addClass('textInput')

        that.model.saveSong(that.model.get('data'), () =>
          that.trigger('change')
        )
      )

      # Buttons
      if model.data?.subtitles?.length <= 0
        this.$('.clearSubtitles').hide()
        this.$('.syncSubtitles').hide()

      if model.data?.translations?[0]?.data?.length <= 0
        this.$('.clearTranslation').hide()

      this.$('.uploadSubtitles').on('click', () =>
        this.$('.editSubtitlesModal').show()
        this.$('.editSubtitlesModal .modal').show()
        this.$('#subtitlesEdit').focus()
      )

      this.$('.clearSubtitles').on('click', () =>
        confirm('Delete subtitles for this song?')
        this.model.saveSubtitles()
      )

      this.$('.uploadTranslation').on('click', () =>
        this.$('.editTranslationModal').show()
        this.$('.editTranslationModal .modal').show()
        this.$('#translationEdit').focus()
      )

      this.$('.clearTranslation').on('click', () =>
        confirm('Delete translation for this song?')
        this.model.saveTranslation()
      )

      this.$('.closeEditSubtitlesModal').click(() =>
        this.$('.editSubtitlesModal').hide()
      )

      this.$('.saveSubtitles').click(() =>
        this.model.saveSubtitles(this.$('#subtitlesEdit').val())
      )

      this.$('.syncSubtitles').click(() =>
        this.$('.syncSubtitlesModal').show()
        this.$('.syncSubtitlesModal .modal').show()
        if this.$('.syncSubtitlesContainer').html().length is 0
          this.$('.syncSubtitlesContainer').html(this.syncView.render().el)
      )
      this.$('.closeSyncSubtitlesModal').click(() =>
        this.$('.syncSubtitlesModal').hide()
        this.model.syncModel.reset()

        # cleanup keyboard events
        window.subtitlesControlsTeardown?()
      )
      this.$('.saveSyncSubtitles').click(() =>
        this.model.syncModel.reset()
        this.model.saveSync()
      )

      this.$('.closeTranslationModal').click(() =>
        this.$('.editTranslationModal').hide()
      )
      this.$('.saveTranslation').click(() =>
        this.model.saveTranslation(this.$('#translationEdit').val())
      )
      
      return this

    formatData: (song) ->
      subtitles = song.subtitles
      translation = song.translations?[0]?.data

      length = Math.max(subtitles?.length || 0, translation?.length || 0)

      formattedData = []
      if length > 0
        for i in [0..length-1]
          translationLine = ''
          subtitleLine = {}

          if translation?.length > i
            translationLine = translation[i]
          if subtitles?.length > i
            subtitleLine = subtitles[i]

          formattedData.push(
            text: subtitleLine?.text
            translation: translationLine
            ts: subtitleLine?.ts || 0
            i: i
          )

      return formattedData

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

  )

  return EditSongView