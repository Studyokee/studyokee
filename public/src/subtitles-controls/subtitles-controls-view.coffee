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
        togglePlayButtonIcon = this.$('.togglePlay .glyphicon')
        if this.model.get('playing')
          togglePlayButtonIcon.removeClass('glyphicon-play')
          togglePlayButtonIcon.addClass('glyphicon-pause')
        else
          togglePlayButtonIcon.removeClass('glyphicon-pause')
          togglePlayButtonIcon.addClass('glyphicon-play')
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
      this.$('.togglePlay').on('click', () =>
        if this.model.get('playing')
          console.log('SUBTITLES CONTROL PAUSE')
          this.model.pause()
        else
          console.log('SUBTITLES CONTROL PLAY')
          this.model.play())
  )

  return SubtitlesControlsView