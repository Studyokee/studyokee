define [
  'backbone',
  'handlebars'
], (Backbone, Handlebars) ->
  DictionaryView = Backbone.View.extend(
    tagName:  "div"
    className: "dictionary"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.renderLookup()
      )

    render: () ->
      this.$el.html(Handlebars.templates['dictionary']())

      this.$('.close').on('click', () =>
        this.trigger('close')
      )

      this.$('.search button').on('click', () =>
        this.model.set(
          query: this.$('.search input').val()
        )
      )

      this.$('.toggleSearch').on('click', () =>
        this.$('.search').fadeToggle(200)
      )

      return this

    renderLookup: () ->
      if this.model.get('isLoading')
        this.$('.lookup').html(Handlebars.templates['spinner']())
      else
        originalTerm = this.model.get('originalTerm')

        if not originalTerm
          this.$('.lookup').html(Handlebars.templates['no-dictionary-results']())
        else
          if this.model.get('lookup')?
            if this.model.get('translationType') is 'mw'
              this.$('.lookup').html(Handlebars.templates['mw-definition'](this.model.toJSON()))
            else
              this.$('.lookup').html(Handlebars.templates['api-reference-definition'](this.model.toJSON()))

  )

  return DictionaryView