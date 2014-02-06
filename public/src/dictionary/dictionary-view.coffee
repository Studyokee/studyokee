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

      return this

    renderLookup: () ->
      if this.model.get('isLoading')
        this.$('.lookup').html(Handlebars.templates['spinner']())
      else
        definitions = this.model.get('definitions')
        hasDefinitions = definitions and definitions.length > 0
        
        uses = this.model.get('uses')
        hasUses = uses and uses.length > 0

        if not hasDefinitions and not hasUses
          this.$('.lookup').html(Handlebars.templates['no-dictionary-results']())
        else
          if this.model.get('lookup')?
            this.$('.lookup').html(Handlebars.templates['api-reference-definition'](this.model.toJSON()))
          if not hasDefinitions
            this.$('.definitions').hide()
          if not hasUses
            this.$('.uses').hide()


  )

  return DictionaryView