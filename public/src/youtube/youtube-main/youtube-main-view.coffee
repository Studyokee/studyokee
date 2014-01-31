define [
  'subtitles.scroller.view',
  'youtube.player.view',
  'dictionary.view',
  'backbone',
  'handlebars',
  'templates'
], (SubtitlesScrollerView, YoutubePlayerView, DictionaryView, Backbone, Handlebars) ->
  YoutubeMainView = Backbone.View.extend(
    tagName:  "div"
    className: "youtubeMain"
    
    initialize: () ->
      this.subtitlesScrollerView = new SubtitlesScrollerView(
        model: this.model.subtitlesScrollerModel
      )

      this.youtubePlayerView  = new YoutubePlayerView(
        model: this.model.youtubePlayerModel
      )

      this.subtitlesScrollerView.on('lookup', (query) =>
        this.trigger('lookup', query)
      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-main'](this.model.toJSON()))

      this.$('.videoPlayerContainer').html(this.youtubePlayerView.render().el)
      this.$('.playerContainer').html(this.subtitlesScrollerView.render().el)

      return this

  )

  return YoutubeMainView