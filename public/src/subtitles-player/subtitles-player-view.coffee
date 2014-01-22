define [
  'backbone',
  'subtitles.scroller.view',
  'subtitles.controls.view',
  'handlebars',
  'templates'
], (Backbone, SubtitlesScrollerView, SubtitlesControlsView, Handlebars) ->

  SubtitlesPlayerView = Backbone.View.extend(
    tagName:  "div"
    className: "player"
    
    initialize: () ->

      this.subtitlesScrollerView = new SubtitlesScrollerView(
        model: this.model
      )

      this.subtitlesControlsView = new SubtitlesControlsView(
        model: this.model
      )

      this.listenTo(this.model, 'change:isLoading', () =>
        this.$('.subtitlesContainer').html(Handlebars.templates['spinner']())
      )
      
      this.listenTo(this.model, 'change:currentSong', () =>
        this.renderCurrentSong()
      )

      this.listenTo(this.model, 'change:subtitles', () =>
        this.$('.subtitlesContainer').html(this.subtitlesScrollerView.render().el)
        this.$('.currentSongContainer').html(Handlebars.templates['current-song'](this.model.toJSON()))
      )

      this.listenTo(this.subtitlesScrollerView, 'lookup', (query) =>
        this.trigger('lookup', query)
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-player'](this.model.toJSON()))
      this.$('.controlsContainer').append(this.subtitlesControlsView.render().el)
      this.$('.subtitlesContainer').html(this.subtitlesScrollerView.render().el)
      this.renderCurrentSong()

      return this

    renderCurrentSong: () ->
      this.$('.currentSongContainer').html(Handlebars.templates['current-song'](this.model.toJSON()))
      if this.model.get('currentSong')?
        this.$('.song').css("visibility", "visible")
      else
        this.$('.song').css("visibility", "hidden")


  )

  return SubtitlesPlayerView