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

      this.inputOpen = false

    render: () ->
      this.$el.html(Handlebars.templates['dictionary'](this.model.toJSON()))

      this.$('.close').on('click', () =>
        this.trigger('close')
      )

      this.$('.search button').on('click', () =>
        this.model.set(
          query: this.$('.search input').val()
        )
      )

      this.$('.toggleSearch').on('click', () =>
        this.inputOpen = !this.inputOpen
        this.$('.search').fadeToggle(200)
      )

      if this.inputOpen
        this.$('.search').show()

      return this

  )

  return DictionaryView