define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  SubtitlesInsertTextView = Backbone.View.extend(
    tagName:  "div"
    className: "insert-text"

    render: () ->
      subtitles = this.model.get('subtitles')
      model =
        text: this.createText(subtitles)
        title: this.options.title
      this.$el.html(Handlebars.templates['subtitles-insert-text'](model))

      this.$('.saveText').on('click', () =>
        this.save()
      )

      return this

    save: () ->
      subtitles = this.createSubtitles(this.$('.editText').val().trim())
      this.trigger('save', subtitles)

    createSubtitles: (lyrics) ->
      lines = lyrics.split('\n')
      subtitles = []
      for line in lines
        subtitle =
          text: line
          ts: 0
        subtitles.push(subtitle)
      return subtitles

    createText: (subtitles) ->
      if not subtitles?
        return ''

      text = ''
      for line in subtitles
        text += line.text + '\n'
      return text
  )

  return SubtitlesInsertTextView