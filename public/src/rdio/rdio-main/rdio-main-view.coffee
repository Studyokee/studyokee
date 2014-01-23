define [
  'subtitles.player.view',
  'rdio.player.view',
  'backbone',
  'handlebars',
  'templates'
], (SubtitlesPlayerView, RdioPlayerView, Backbone, Handlebars) ->
  RdioMainView = Backbone.View.extend(
    tagName:  "div"
    className: "rdioMain"
    
    initialize: () ->

      this.rdioPlayerView = new RdioPlayerView(
        model: this.model.rdioPlayerModel
      )

      this.subtitlesPlayerView = new SubtitlesPlayerView(
        model: this.model.subtitlesPlayerModel
      )

      this.subtitlesPlayerView.on('lookup', (query) =>
        this.trigger('lookup', query)
      )

    render: () ->
      this.$el.html(Handlebars.templates['rdio-main'](this.model.toJSON()))

      this.$('.rdioPlayerContainer').html(this.rdioPlayerView.render().el)
      this.$('.playerContainer').html(this.subtitlesPlayerView.render().el)

      return this

  )

  return RdioMainView