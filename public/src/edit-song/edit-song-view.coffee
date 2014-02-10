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

      view = this
      this.$('.cancel').on('click', (event) ->
        document.location = '../../../songs/edit/'
        event.preventDefault()
      )
      this.$('.save').on('click', (event) =>
        this.saveSong()
        event.preventDefault()
      )

      if model.data?.subtitles?
        this.$('.subtitles').attr('rows', model.data.subtitles.length + 3)
      if model.data?.translations?.length > 0 and model.data.translations[0].data?
        this.$('.translation').attr('rows', model.data.translations[0].data.length + 3)

      this.$('.translation-toggle').on('click', () =>
        dropdown = this.$('.translation-dropdown')
        if dropdown.hasClass('open')
          dropdown.removeClass('open')
        else
          dropdown.addClass('open')
      )


      return this

    createTextFromSubtitles: (subtitles) ->
      if not subtitles?
        return ''

      text = ''
      for line in subtitles
        text += '[' + line.ts + ']' + line.text + '\n'
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