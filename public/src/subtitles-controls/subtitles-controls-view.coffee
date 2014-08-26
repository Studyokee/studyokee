define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  SubtitlesControlsView = Backbone.View.extend(
    tagName:  "div"
    className: "controls"

    initialize: () ->
      this.listenTo(this.model, 'change:playing', () =>
        togglePlayButtonIcon = this.$('.toggle-play .glyphicon')
        if this.model.get('playing')
          togglePlayButtonIcon.removeClass('glyphicon-play')
          togglePlayButtonIcon.addClass('glyphicon-pause')
          this.updateProgressBar()
        else
          togglePlayButtonIcon.removeClass('glyphicon-pause')
          togglePlayButtonIcon.addClass('glyphicon-play')
          clearTimeout(this.progressTick)
      )
      this.listenTo(this.model, 'change:currentSong', () =>
        this.$('.progress-bar').width('0%')
      )
      this.listenTo(this.model, 'change:i', () =>
        this.setProgressBar()
      )
      this.listenTo(this.model, 'change:presentationMode', () =>
        togglePresentationModeButton = this.$('.toggle-presentation-mode')
        togglePresentationModeIcon = this.$('.toggle-presentation-mode .glyphicon')
        if this.model.get('presentationMode')
          togglePresentationModeIcon.removeClass('glyphicon-resize-full')
          togglePresentationModeIcon.addClass('glyphicon-resize-small')
          togglePresentationModeButton.prop('title', 'Leave Presentation Mode')
        else
          togglePresentationModeIcon.removeClass('glyphicon-resize-small')
          togglePresentationModeIcon.addClass('glyphicon-resize-full')
          togglePresentationModeButton.prop('title', 'Enter Presentation Mode')
      )
      this.enableKeyboard()

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-controls'](this.model.toJSON()))
      this.$('.pause').hide()
      this.enableButtons()

      return this

    setProgressBar: () ->
      percentage = this.model.getCurrentPercentageComplete()
      this.$('.progress-bar').width(percentage + '%')

    updateProgressBar: () ->
      clearTimeout(this.progressTick)
      this.setProgressBar()
      next = () =>
        this.updateProgressBar()
      this.progressTick = setTimeout(next, 100)

    toStart: () ->
      console.log('SUBTITLES CONTROL TO START')
      this.model.toStart()

    prev: () ->
      console.log('SUBTITLES CONTROL PREV')
      this.model.prev()

    next: () ->
      console.log('SUBTITLES CONTROL NEXT')
      this.model.next()

    togglePlay: () ->
      if this.model.get('playing')
        console.log('SUBTITLES CONTROL PAUSE')
        this.model.pause()
      else
        console.log('SUBTITLES CONTROL PLAY')
        this.model.play()

    togglePresentationMode: () ->
      console.log('SUBTITLES CONTROL TOGGLE PREZ')
      if this.model.get('presentationMode')
        this.trigger('leavePresentationMode')
      else
        this.trigger('enterPresentationMode')
      this.model.set(
        presentationMode: not this.model.get('presentationMode')
      )

    toggleVideo: () ->
      console.log('SUBTITLES CONTROL TOGGLE VIDEO')
      toggleVideoButton = this.$('.toggle-video')
      toggleVideoIcon = this.$('.toggle-video .glyphicon')
      if toggleVideoIcon.hasClass('glyphicon-collapse-up')
        this.trigger('hideVideo')
        toggleVideoIcon.removeClass('glyphicon-collapse-up')
        toggleVideoIcon.addClass('glyphicon-collapse-down')
        toggleVideoButton.prop('title', 'Show Video')
      else
        this.trigger('showVideo')
        toggleVideoIcon.addClass('glyphicon-collapse-up')
        toggleVideoIcon.removeClass('glyphicon-collapse-down')
        toggleVideoButton.prop('title', 'Hide Video')

    enableButtons: () ->
      this.$('.toStart').on('click', () =>
        this.toStart())
      this.$('.prev').on('click', () =>
        this.prev())
      this.$('.next').on('click', () =>
        this.next())
      this.$('.toggle-play').on('click', () =>
        this.togglePlay())
      this.$('.toggle-presentation-mode').on('click', () =>
        this.togglePresentationMode())
      this.$('.toggle-video').on('click', () =>
        this.toggleVideo())

    enableKeyboard: () ->
      $(window).keydown((event) =>
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
  )

  return SubtitlesControlsView