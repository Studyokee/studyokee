define [
  'backbone',
  'handlebars'
], (Backbone, Handlebars) ->

  DictionaryView = Backbone.View.extend(
    className: "dictionary"

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['dictionary'](this.model.toJSON()))

      return this
  )

  return DictionaryView