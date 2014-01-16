define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  EditSubtitlesView = Backbone.View.extend(
    tagName:  "div"
    className: "edit-subtitles"

    render: () ->
      subtitles = this.model.get('subtitles')
      model =
        original: this.createTextFromSubtitles(subtitles.original)
      
      this.$el.html(Handlebars.templates['edit-subtitles'](model))

      this.$('.editText').attr('rows', subtitles.original.length)

      this.$('.saveText').on('click', () =>
        this.save()
      )

      return this

    save: () ->
      rawText = this.$('.editText').val().trim()
      subtitles = this.createSubtitlesFromText(rawText)
      this.trigger('save', subtitles)

    createSubtitlesFromText: (text) ->
      lines = text.split('\n')
      subtitles = []
      for line in lines
        regexTs = /\[([0-9]+)\]/
        ts = line.match(regexTs)[1]
        regexText = /\[[0-9]+\](.*)/
        text = line.match(regexText)[1]
        subtitle =
          text: text
          ts: ts
        subtitles.push(subtitle)

      return subtitles

    createTextFromSubtitles: (subtitles) ->
      if not subtitles?
        return ''

      text = ''
      for line in subtitles
        text += '[' + line.ts + ']' + line.text + '\n'
      return text
  )

  return EditSubtitlesView