define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  SubtitlesControlsView = Backbone.View.extend(
    className: "controls"

    initialize: (options) ->
      this.options = options
      this.listenTo(this.model, 'change:state', () =>
        this.updatePlayButton()
      )
      this.listenTo(this.model, 'change:loadingVideo', () =>
        this.render()
      )

      this.onKeyDownEvent = (event) =>
        if $(event.target).is('input') or $(event.target).is('textarea')
          return
        this.onKeyDown(event)
      $(window).on('keydown', this.onKeyDownEvent)

      window.subtitlesControlsTeardown = this.teardown

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-controls'](this.model.toJSON()))
      this.$('.pause').hide()

      this.enableButtons()

      this.$('[data-toggle="popover"]').popover()

      return this

    updatePlayButton: ->
      togglePlayButtonIcon = this.$('.toggle-play .glyphicon')
      if this.model.get('state') is 3
        togglePlayButtonIcon.removeClass('glyphicon-play')
        togglePlayButtonIcon.removeClass('glyphicon-pause')
        togglePlayButtonIcon.addClass('glyphicon-spin')
      else
        if this.model.get('playing')
          togglePlayButtonIcon.removeClass('glyphicon-play')
          togglePlayButtonIcon.removeClass('glyphicon-spin')
          togglePlayButtonIcon.addClass('glyphicon-pause')
        else
          togglePlayButtonIcon.removeClass('glyphicon-pause')
          togglePlayButtonIcon.removeClass('glyphicon-spin')
          togglePlayButtonIcon.addClass('glyphicon-play')
          clearTimeout(this.progressTick)

    teardown: ->
      $(window).off('keydown', this.onKeyDownEvent)

    toStart: () ->
      this.model.toStart()

    prev: () ->
      this.model.prev()

    next: () ->
      this.model.next()

    togglePlay: () ->
      if this.model.get('playing')
        this.model.pause()
      else
        this.model.play()

    toggleTranslation: () ->
      this.trigger('toggleTranslation')

      toggleTranslationButton = this.$('.toggle-translation')
      if (!toggleTranslationButton.hasClass('active'))
        toggleTranslationButton.addClass('active')
        toggleTranslationButton.text('Show English')
      else
        toggleTranslationButton.removeClass('active')
        toggleTranslationButton.text('Hide English')

    enableButtons: () ->
      this.$('.prev').on('click', () =>
        this.prev())
      this.$('.next').on('click', () =>
        this.next())
      this.$('.toggle-play').on('click', () =>
        this.togglePlay())
      this.$('.toggle-translation').on('click', () =>
        this.toggleTranslation())


    onKeyDown: (event) ->
      if event.which is 37
        this.prev()
        event.preventDefault()
      if event.which is 39
        this.next()
        event.preventDefault()
      if event.which is 32
        this.togglePlay()
        event.preventDefault()
  )

  return SubtitlesControlsView