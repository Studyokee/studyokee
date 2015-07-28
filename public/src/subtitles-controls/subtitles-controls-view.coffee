define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  SubtitlesControlsView = Backbone.View.extend(
    tagName:  "div"
    className: "controls"

    initialize: (options) ->
      this.options = options
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

      this.onKeyDownEvent = (event) =>
        this.onKeyDown(event)
      $(window).on('keydown', this.onKeyDownEvent)
      window.subtitlesControlsTeardown = this.teardown

    teardown: ->
      console.log('teardown keyboard')
      $(window).off('keydown', this.onKeyDownEvent)

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-controls'](this.model.toJSON()))
      this.$('.pause').hide()

      if not this.options.allowToggleVideo
        this.$('.toggle-video').remove()
      if not this.options.allowHideTranslation
        this.$('.toggle-translation').remove()

      this.enableButtons()

      return this

    setProgressBar: () ->
      percentage = this.model.getCurrentPercentageComplete()
      time = this.convertSecondsToTime(this.model.getCurrentTime()/1000)
      duration = this.convertSecondsToTime(this.model.getDuration())
      this.$('.progress-bar').width(percentage + '%')
      this.$('.progress-timer').html(time + '/' + duration)

    convertSecondsToTime: (seconds) ->
      partOne = Math.floor(seconds / 60)
      partTwo = Math.floor(seconds) % 60
      if partTwo < 10
        partTwo = '0' + partTwo

      if isNaN(partOne) or isNaN(partTwo)
        return '0:00'

      return partOne + ':' + partTwo

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

    toggleTranslation: () ->
      console.log('SUBTITLES CONTROL TOGGLE TRANSLATION')
      toggleButton = this.$('.toggle-translation')
      toggleIcon = this.$('.toggle-translation .glyphicon')
      if toggleIcon.hasClass('glyphicon-eye-close')
        this.trigger('hideTranslation')
        toggleIcon.removeClass('glyphicon-eye-close')
        toggleIcon.addClass('glyphicon-eye-open')
        toggleButton.prop('title', 'Show Translation')
      else
        this.trigger('showTranslation')
        toggleIcon.addClass('glyphicon-eye-close')
        toggleIcon.removeClass('glyphicon-eye-open')
        toggleButton.prop('title', 'Hide Translation')

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
      this.$('.toggle-translation').on('click', () =>
        this.toggleTranslation())

    onKeyDown: (event) ->
      if event.which is 49
        this.prev()
        event.preventDefault()
      if event.which is 50
        this.next()
        event.preventDefault()
      if event.which is 51
        this.togglePlay()
        event.preventDefault()
  )

  return SubtitlesControlsView