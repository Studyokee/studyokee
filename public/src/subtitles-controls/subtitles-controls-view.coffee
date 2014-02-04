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
        playButton = this.$('.play')
        if this.model.get('playing')
          playButton.html('||')
        else
          playButton.html('→')
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
      this.$('.play').on('click', () =>
        if this.model.get('playing')
          console.log('SUBTITLES CONTROL PAUSE')
          this.model.pause()
        else
          console.log('SUBTITLES CONTROL PLAY')
          this.model.play())
  )

  return SubtitlesControlsView