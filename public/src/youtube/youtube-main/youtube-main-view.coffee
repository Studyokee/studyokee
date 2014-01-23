define [
  'subtitles.player.view',
  'youtube.player.view',
  'dictionary.view',
  'backbone',
  'handlebars',
  'templates'
], (SubtitlesPlayerView, YoutubePlayerView, DictionaryView, Backbone, Handlebars) ->
  YoutubeMainView = Backbone.View.extend(
    tagName:  "div"
    className: "youtubeMain"
    
    initialize: () ->
      this.subtitlesPlayerView = new SubtitlesPlayerView(
        model: this.model.subtitlesPlayerModel
      )

      this.youtubePlayerView  = new YoutubePlayerView(
        model: this.model.youtubePlayerModel
      )

      this.subtitlesPlayerView.on('lookup', (query) =>
        this.trigger('lookup', query)
      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-main'](this.model.toJSON()))

      this.$('.videoPlayerContainer').html(this.youtubePlayerView.render().el)
      this.$('.playerContainer').html(this.subtitlesPlayerView.render().el)

      return this

  )

  return YoutubeMainView