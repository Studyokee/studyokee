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
        if $(event.target).is('input') or $(event.target).is('textarea')
          return
        this.onKeyDown(event)
      $(window).on('keydown', this.onKeyDownEvent)
      window.subtitlesControlsTeardown = this.teardown

    teardown: ->
      $(window).off('keydown', this.onKeyDownEvent)

    render: () ->
      if this.model.get('words') is null
        this.$el.html('<span class="glyphicon glyphicon-refresh glyphicon-spin large-spinner"></span>')
      else if this.model.get('words').length is 0
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

        this.$('[data-toggle="popover"]').popover()

      this.$('#editCardModal').on('show.bs.modal', () =>
        currentWord = this.model.get('words')[this.model.get('index')]
        this.$('#editCardModal .cardWord').text(currentWord.word)
        this.$('#editCardModal .cardDef').val(currentWord.def)
      )

      this.$('#editCardModal .saveCard').click(() =>
        this.edit()
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

    edit: () ->
      currentWord = this.model.get('words')[this.model.get('index')]
      currentWord.def = this.$('#editCardModal .cardDef').val()
      if currentWord.def
        $('#editCardModal').modal('hide')
        $('body').removeClass('modal-open')
        $('.modal-backdrop').remove()
        this.model.trigger('updateWord', currentWord)
        this.render()

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