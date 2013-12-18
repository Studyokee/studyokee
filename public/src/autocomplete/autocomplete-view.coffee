define [
  'backbone'
], (Backbone) ->
  AutocompleteView = Backbone.View.extend(
    tagName:  "div"
    className: "ac"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      suggestions = this.model.get('suggestions')
      if suggestions and suggestions.length > 0
        # filter down to 5 results
        data =
          suggestions: suggestions.slice(0, 5)
        this.$el.html(Handlebars.templates['autocomplete'](data))

        view = this
        this.$('.suggestion').on('click', (event) ->
          index = $(this).attr('data-index')
          view.trigger('select', suggestions[index])
        )

      return this
  )

  return AutocompleteView