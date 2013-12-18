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
        console.log('enable keyboard player: ' + enableKeyboard)

        if enableKeyboard
          this.enableKeyboard()
        else
          this.disableKeyboard()
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-controls']())
      this.enableKeyboard()
      this.enableButtons()

      return this

    enableKeyboard: () ->
      console.log('enableKeyboard controls')
      this.keydown = (event) =>
        this.onKeyDown(event)
      $(window).on('keydown', this.keydown)
      $(window).on('keyup', (event) =>
        this.$('.control').removeClass('active')
      )

    disableKeyboard: () ->
      console.log('disableKeyboard controls')
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
          # s83 or space32, down arrow
          this.$('.play').addClass('active')
          this.model.play()

          event.preventDefault()
        when 38
          # w87 or up arrow
          this.$('.pause').addClass('active')
          this.model.pause()

          event.preventDefault()
        when 39
          # d68 or right arrow
          this.$('.next').addClass('active')
          this.model.next()
        #else
        #  console.log(event.keyCode)
      
  )

  return SubtitlesControlsView