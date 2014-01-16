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

  )

  return SubtitlesInsertTextView