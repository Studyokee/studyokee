define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  VocabularySliderView = Backbone.View.extend(
    tagName:  'div'
    className: 'vocabulary-slider'

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      console.log('render slider')
      console.log(JSON.stringify(this.model.toJSON()))
      if this.model.get('words').length is 0
        this.$el.html('<div class="noResults">No words to study!</div>')
      else
        this.$el.html(Handlebars.templates['vocabulary-slider'](this.model.toJSON()))
        $(this.$el.find('.card')[this.model.get('index')]).addClass('active')

        view = this
        this.$('.next').on('click', () ->
          if !view.model.get('showDefinition')
            view.model.set(
              showDefinition: true
            )
          else
            view.model.set(
              index: (view.model.get('index')+1) % view.model.get('words').length
              showDefinition: false
            )
        )
        this.$('.prev').on('click', () ->
          if view.model.get('showDefinition')
            view.model.set(
              showDefinition: false
            )
          else
            nextIndex = view.model.get('index')-1
            if nextIndex < 0
              return
            view.model.set(
              index: nextIndex
              showDefinition: true
            )
        )
        this.$('.remove').on('click', () ->
          view.model.remove(view.model.get('index'))
        )

      return this
      
  )

  return VocabularySliderView