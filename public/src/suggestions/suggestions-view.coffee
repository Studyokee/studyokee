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
        this.showSuggestions()
      )

    render: () ->
      this.showSuggestions()

      return this

    showSuggestions: () ->
      model =
        suggestions: this.model.get('suggestions')

      this.$el.html(Handlebars.templates['suggestions'](model))

      this.$('a').on('click', (event) =>
        target = $(event.target)
        song =
          id: target.attr('data-id')
        this.model.set(
          selectedSong: song
        )
      )
  )

  return SuggestionsView