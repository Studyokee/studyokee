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
    className: "youtube-main"
    
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

      this.youtubePlayerView.on('enterPresentationMode', () =>
        this.trigger('enterPresentationMode')
        this.subtitlesScrollerView.trigger('sizeChange')
      )
      this.youtubePlayerView.on('leavePresentationMode', () =>
        this.trigger('leavePresentationMode')
        this.subtitlesScrollerView.trigger('sizeChange')
      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-main'](this.model.toJSON()))

      this.$('.video-player-container').html(this.youtubePlayerView.render().el)
      this.$('.player-container').html(this.subtitlesScrollerView.render().el)

      return this

  )

  return YoutubeMainView