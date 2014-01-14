define [
  'backbone',
  'handlebars'
], (Backbone, Handlebars) ->
  DictionaryView = Backbone.View.extend(
    tagName:  "div"
    className: "dictionary"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['dictionary'](this.model.toJSON()))

      if this.model.get('isLoading')
        this.$('.lookup').html(Handlebars.templates['spinner']())
      else
        this.$('.lookup').html(this.model.get('lookup'))

      return this
  )

  return DictionaryView