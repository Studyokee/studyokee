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
      model = this.model.toJSON()
      if model.data?.subtitles?
        model.subtitlesText = this.createTextFromSubtitles(model.data.subtitles)

      if model.data?.translations?.length > 0
        translation = model.data.translations[0].data
        model.translationText = translation.join('\n')

      this.$el.html(Handlebars.templates['edit-song'](model))

      this.renderLyricsTable(model)
      this.renderForm()
      this.renderModals()
      
      return this

    renderLyricsTable: (model) ->
      if model.data?
        subtitles = model.data.subtitles
        if subtitles.length is 0
          subtitles = [text: 'There are no subtitles yet.']

        translation = []
        if model.data?.translations?.length > 0
          translation = model.data.translations[0].data
        if translation.length is 0
          translation = ['There is no translation yet.']

        tableBody = ''
        length = Math.max(subtitles.length, translation.length)
        for i in [0..length]
          subtitleLine = ''
          if subtitles.length > i
            if subtitles[i]?.ts?
              subtitleLine = '(' + subtitles[i]?.ts + ') ' + subtitles[i].text
            else
              subtitleLine = subtitles[i].text

          translationLine = ''
          if translation.length > i
            translationLine = translation[i]

          tableBody += '<tr>'
          tableBody += '<td class="col-lg-6">' + subtitleLine + '</td>'
          tableBody += '<td class="col-lg-6">' + translationLine + '</td>'
          tableBody += '</tr>'

        this.$('.songText').html(tableBody)

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
        document.location = '../../../songs/edit/')
  )

  return EditSongView