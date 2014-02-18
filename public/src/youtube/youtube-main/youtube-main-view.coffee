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
        this.enterPresentationMode()
        this.subtitlesScrollerView.trigger('sizeChange')
      )
      this.youtubePlayerView.on('leavePresentationMode', () =>
        this.trigger('leavePresentationMode')
        this.leavePresentationMode()
        this.subtitlesScrollerView.trigger('sizeChange')
      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-main'](this.model.toJSON()))

      this.$('.video-player-container').html(this.youtubePlayerView.render().el)
      this.$('.player-container').html(this.subtitlesScrollerView.render().el)

      return this

    enterPresentationMode: () ->
      this.$('.video-player-container').addClass('col-lg-6')
      this.$('.player-container').addClass('col-lg-6')

    leavePresentationMode: () ->
      this.$('.video-player-container').removeClass('col-lg-6')
      this.$('.player-container').removeClass('col-lg-6')

    calculateYTPlayerHeight: () ->
      ytPlayerWidth = this.$('#ytPlayer').width()
      ytPlayerHeight = ytPlayerWidth * 0.75
      this.$('#ytPlayer').height(ytPlayerHeight + 'px')

  )

  return YoutubeMainView