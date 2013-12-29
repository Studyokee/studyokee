define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  SubtitlesControlsView = Backbone.View.extend(
    tagName:  "div"
    className: "controls"

    initialize: () ->
      this.listenTo(this.model, 'change:enableKeyboard', () =>
        enableKeyboard = this.model.get('enableKeyboard')

        if enableKeyboard
          this.enableKeyboard()
        else
          this.disableKeyboard()
      )

      this.listenTo(this.model, 'change:isPlaying', () =>
        if this.model.get('isPlaying')
          this.$('.play').hide()
          this.$('.pause').show()
        else
          this.$('.pause').hide()
          this.$('.play').show()
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-controls'](this.model.toJSON()))
      this.enableKeyboard()
      this.enableButtons()

      return this

    enableKeyboard: () ->
      this.keydown = (event) =>
        this.onKeyDown(event)
      $(window).on('keydown', this.keydown)
      $(window).on('keyup', (event) =>
        this.$('.control').removeClass('active')
      )

    disableKeyboard: () ->
      $(window).unbind('keydown', this.keydown)

    enableButtons: () ->
      this.$('.prev').on('click', () =>
        this.model.prev())
      this.$('.next').on('click', () =>
        this.model.next())
      this.$('.play').on('click', () =>
        this.model.play())
      this.$('.pause').on('click', () =>
        this.model.pause())

    onKeyDown: (event) ->
      switch event.keyCode
        when 37
          # a65 or left arrow
          this.$('.prev').addClass('active')
          this.model.prev()
        when 40
          # down arrow
          if this.model.get('isPlaying')
            this.$('.pause').addClass('active')
            this.model.pause()
          else
            this.$('.play').addClass('active')
            this.model.play()

          event.preventDefault()
        when 39
          # d68 or right arrow
          this.$('.next').addClass('active')
          this.model.next()
        #else
        #  console.log(event.keyCode)
      
  )

  return SubtitlesControlsView