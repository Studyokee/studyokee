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

      this.onKeyDownEvent = (event) =>
        this.onKeyDown(event)
      $(window).on('keydown', this.onKeyDownEvent)
      window.subtitlesControlsTeardown = this.teardown

    teardown: ->
      console.log('teardown keyboard')
      $(window).off('keydown', this.onKeyDownEvent)

    render: () ->
      console.log('render slider')
      if this.model.get('words').length is 0
        this.$el.html('<div class="noResults">No words to study!</div>')
      else
        this.$el.html(Handlebars.templates['vocabulary-slider'](this.model.toJSON()))
        $(this.$el.find('.card')[this.model.get('index')]).addClass('active')

        this.$('.next').on('click', () =>
          this.next()
        )
        this.$('.prev').on('click', () =>
          this.prev()
        )
        this.$('.remove').on('click', () =>
          this.remove()
        )
        this.$('.panel-link').on('click', () =>
          this.next()
        )

      return this

    next: () ->
      if this.$('.flip-container').hasClass('flip')
        this.model.set(
          index: (this.model.get('index')+1) % this.model.get('words').length
        )
        this.model.trigger('change')
      else
        this.$('.flip-container').addClass('flip')


    remove: () ->
      this.model.remove(this.model.get('index'))


    onKeyDown: (event) ->
      if event.which is 39
        this.next()
        event.preventDefault()
      if event.which is 32
        this.remove()
        event.preventDefault()
      
  )

  return VocabularySliderView