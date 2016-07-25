define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  VocabularyListView = Backbone.View.extend(
    tagName:  'div'
    className: 'vocabulary-list'

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['vocabulary-list'](this.model.toJSON()))

      return this
  )

  return VocabularyListView