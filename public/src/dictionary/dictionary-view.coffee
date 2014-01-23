define [
  'backbone',
  'handlebars'
], (Backbone, Handlebars) ->
  DictionaryView = Backbone.View.extend(
    tagName:  "div"
    className: "dictionary"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        if this.model.get('isLoading')
          this.$('.lookup').html(Handlebars.templates['spinner']())
        else
          this.$('.lookup').html(this.model.get('lookup'))
      )

    render: () ->
      this.$el.html(Handlebars.templates['dictionary'](this.model.toJSON()))

      this.$('.close').on('click', () =>
        this.trigger('close')
      )

      return this
  )

  return DictionaryView