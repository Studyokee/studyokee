define [
  'backbone'
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  SuggestionsView = Backbone.View.extend(
    tagName:  "div"
    className: "suggestions"

    initialize: () ->
      this.listenTo(this.model, 'change:suggestions', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['suggestions'](this.model.toJSON()))

      that = this
      this.$('a').on('click', (event) ->
        target = $(event.target)
        key = $(this).attr('data-key')
        song = that.model.getSuggestion(key)
        that.model.set(
          selectedSong: song
        )
      )

      return this
  )

  return SuggestionsView