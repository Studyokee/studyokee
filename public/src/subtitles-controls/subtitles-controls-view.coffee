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
        else
          togglePlayButtonIcon.removeClass('glyphicon-pause')
          togglePlayButtonIcon.addClass('glyphicon-play')
      )
      this.listenTo(this.model, 'change:presentationMode', () =>
        togglePresentationModeButton = this.$('.toggle-presentation-mode')
        togglePresentationModeIcon = this.$('.toggle-presentation-mode .glyphicon')
        if this.model.get('presentationMode')
          togglePresentationModeIcon.removeClass('glyphicon-fullscreen')
          togglePresentationModeIcon.addClass('glyphicon-collapse-down')
          togglePresentationModeButton.prop('title', 'Leave Presentation Mode')
        else
          togglePresentationModeIcon.removeClass('glyphicon-collapse-down')
          togglePresentationModeIcon.addClass('glyphicon-fullscreen')
          togglePresentationModeButton.prop('title', 'Enter Presentation Mode')
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-controls'](this.model.toJSON()))
      this.$('.pause').hide()
      this.enableButtons()

      return this

    enableButtons: () ->
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
  )

  return SubtitlesControlsView