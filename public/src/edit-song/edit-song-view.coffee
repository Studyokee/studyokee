define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  EditSongView = Backbone.View.extend(
    className: "editSong"
    
    initialize: () ->
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
            subtitleLine = subtitles[i].text

          translationLine = ''
          if translation.length > i
            translationLine = translation[i]

          tableBody += '<tr>'
          tableBody += '<td class="col-lg-6">' + subtitleLine + '</td>'
          tableBody += '<td class="col-lg-6">' + translationLine + '</td>'
          tableBody += '</tr>'

        this.$('.songText').html(tableBody)

      view = this
      this.$('.cancel').on('click', (event) ->
        window.history.back()
        event.preventDefault()
      )
      this.$('.save').on('click', (event) =>
        song = this.model.get('data')
        song.metadata.trackName = this.$('#trackName').val()
        song.metadata.artist = this.$('#artist').val()
        song.metadata.language = this.$('#language').val()
        this.model.saveSong(song)
        event.preventDefault()
      )

      this.$('.editSubtitles').on('click', (event) =>
        this.$('.editSubtitlesModal').show()
        event.preventDefault()
      )
      this.$('.closeSubtitlesModal').click(() =>
        this.$('.editSubtitlesModal').hide()
        event.preventDefault()
      )
      this.$('.syncSubtitles').click(() =>
        success = () =>
          this.$('.editSubtitlesModal').hide()

        this.model.saveSubtitles(this.$('#subtitlesEdit').val(), success)
        event.preventDefault()
      )

      this.$('.editTranslation').on('click', (event) =>
        this.$('.editTranslationModal').show()
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

      if model.data?
        this.$('#language').val(model.data?.metadata?.language)

      if model.data?.youtubeKey?
        this.$('#youtubeKey').val('http://www.youtube.com/watch?v=' + model.data.youtubeKey)

      return this

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