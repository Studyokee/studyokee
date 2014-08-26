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

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-controls'](this.model.toJSON()))
      this.$('.pause').hide()
      this.enableButtons()

      return this

    setProgressBar: () ->
      percentage = this.model.getCurrentPercentageComplete()
      this.$('.progress-bar').width(percentage + '%')

    updateProgressBar: () ->
      this.setProgressBar()
      next = () =>
        this.updateProgressBar()
      this.progressTick = setTimeout(next, 100)

    enableButtons: () ->
      this.$('.toStart').on('click', (event) =>
        console.log('SUBTITLES CONTROL TO START')
        this.model.toStart())
      this.$('.prev').on('click', (event) =>
        console.log('SUBTITLES CONTROL PREV')
        this.model.prev())
      this.$('.next').on('click', () =>
        console.log('SUBTITLES CONTROL NEXT')
        this.model.next())
      this.$('.toggle-play').on('click', () =>
        if this.model.get('playing')
          console.log('SUBTITLES CONTROL PAUSE')
          this.model.pause()
        else
          console.log('SUBTITLES CONTROL PLAY')
          this.model.play())
      this.$('.toggle-presentation-mode').on('click', () =>
        console.log('SUBTITLES CONTROL TOGGLE PREZ')
        if this.model.get('presentationMode')
          this.trigger('leavePresentationMode')
        else
          this.trigger('enterPresentationMode')
        this.model.set(
          presentationMode: not this.model.get('presentationMode')
        )
      )
      this.$('.toggle-video').on('click', () =>
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
      )
  )

  return SubtitlesControlsView