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
        if this.model.get('playing')
          this.$('.play').hide()
          this.$('.pause').show()
        else
          this.$('.pause').hide()
          this.$('.play').show()
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-controls'](this.model.toJSON()))
      this.$('.pause').hide()
      this.enableButtons()

      return this

    enableButtons: () ->
      this.$('.prev').on('click', () =>
        console.log('SUBTITLES CONTROL PREV')
        this.model.prev())
      this.$('.next').on('click', () =>
        console.log('SUBTITLES CONTROL NEXT')
        this.model.next())
      this.$('.play').on('click', () =>
        console.log('SUBTITLES CONTROL PLAY')
        this.model.play())
      this.$('.pause').on('click', () =>
        console.log('SUBTITLES CONTROL PAUSE')
        this.model.pause())
  )

  return SubtitlesControlsView