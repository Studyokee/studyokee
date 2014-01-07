define [
  'backbone',
  'subtitles.scroller.view',
  'subtitles.controls.view',
  'handlebars',
  'templates'
], (Backbone, SubtitlesScrollerView, SubtitlesControlsView, Handlebars) ->

  ####################################################################
  #
  # SubtitlesPlayerView
  #
  # The view for the collection of original subtitles, translated
  # subtitles, controls, and dictionary lookup
  #
  ####################################################################
  SubtitlesPlayerView = Backbone.View.extend(
    tagName:  "div"
    className: "player"
    
    initialize: () ->

      this.subtitlesView = new SubtitlesScrollerView(
        model: this.model
      )

      this.subtitlesControlsView = new SubtitlesControlsView(
        model: this.model
      )

      this.listenTo(this.model, 'change', () =>
        this.renderUpdate()
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-player'](this.model.toJSON()))
      this.$('.controlsContainer').append(this.subtitlesControlsView.render().el)

      this.renderUpdate()

      return this

    renderUpdate: () ->
      this.$('.currentSongContainer').html(Handlebars.templates['current-song'](this.model.toJSON()))

      if this.model.get('isLoading')
        this.$('.subtitlesContainer').html(Handlebars.templates['spinner']())
      else
        this.$('.subtitlesContainer').html(this.subtitlesView.render().el)

      if this.model.get('currentSong')?
        this.$('.song').css("visibility", "visible")
      else
        this.$('.song').css("visibility", "hidden")
  )

  return SubtitlesPlayerView