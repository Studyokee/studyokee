define [
  'dictionary.view',
  'subtitles.scroller.view',
  'subtitles.controls.view'
  'youtube.player.view',
  'backbone',
  'handlebars',
  'templates'
], (DictionaryView, SubtitlesScrollerView, SubtitlesControlsView, YoutubePlayerView, Backbone, Handlebars) ->
  YoutubeMainView = Backbone.View.extend(
    tagName:  'div'
    className: 'youtube-main'
    
    initialize: () ->

      this.subtitlesControlsView = new SubtitlesControlsView(
        model: this.model
        allowHideTranslation: true
      )

      this.subtitlesControlsView.on('toggleTranslation', () =>
        this.trigger('toggleTranslation')
      )

      this.listenTo(this.model, 'change', () =>
        this.render()
      )

      this.subtitlesScrollerView = new SubtitlesScrollerView(
        model: this.model.subtitlesScrollerModel
      )

      this.youtubePlayerView  = new YoutubePlayerView(
        model: this.model.youtubePlayerModel
      )

      this.dictionaryView = new DictionaryView(
        model: this.model.dictionaryModel
      )

      this.subtitlesScrollerView.on('lookup', (query) =>
        this.dictionaryModel.set(
          query: query
        )
        this.model.youtubePlayerModel.pause()
      )
      this.subtitlesScrollerView.on('toggle', (query) =>
        this.model.youtubePlayerModel.toggle()
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

      this.youtubePlayerView.on('toggleTranslation', () =>
        scrollerEl = this.$el.find('.subtitles-scroller')
        if (scrollerEl.hasClass('show-translation'))
          scrollerEl.removeClass('show-translation')
        else
          scrollerEl.addClass('show-translation')

      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-main'](this.model.toJSON()))

      this.$('.video-player-container').html(this.youtubePlayerView.render().el)
      this.$('.player-container').html(this.subtitlesScrollerView.render().el)
      this.$('.controls-container').html(this.subtitlesControlsView.render().el)

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