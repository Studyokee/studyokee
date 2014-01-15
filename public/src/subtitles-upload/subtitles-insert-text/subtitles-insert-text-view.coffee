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
        original: this.createTextFromSubtitles(subtitles.original)
        translation: subtitles.translation.join('\n')
      this.$el.html(Handlebars.templates['subtitles-insert-text'](model))

      this.$('.translatedText').attr('rows', subtitles.translation.length)

      this.$('.saveText').on('click', () =>
        this.save()
      )

      return this

    save: () ->
      translation = this.$('.translatedText').val().trim().split('\n')
      this.trigger('save', translation)

    # createSubtitlesFromText: (lyrics) ->
    #   lines = lyrics.split('\n')
    #   subtitles = []
    #   for line in lines
    #     subtitle =
    #       text: line
    #       ts: 0
    #     subtitles.push(subtitle)
    #   return subtitles

    createTextFromSubtitles: (subtitles) ->
      if not subtitles?
        return ''

      text = ''
      for line in subtitles
        text += line.text + '\n'
      return text
  )

  return SubtitlesInsertTextView