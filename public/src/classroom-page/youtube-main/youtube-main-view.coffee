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
        model: this.model.youtubePlayerModel
        allowHideTranslation: true
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

      this.listenTo(this.model, 'change:currentSong', () =>
        this.render()
      )

      this.subtitlesControlsView.on('toggleTranslation', () =>
        this.subtitlesScrollerView.trigger('toggleTranslation')
      )

      this.subtitlesScrollerView.on('lookup', (query) =>
        this.trigger('lookup', query)
        this.model.dictionaryModel.set(
          query: query
        )
        this.model.youtubePlayerModel.pause()
      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-main'](this.model.toJSON()))

      this.$('.video-player-container').html(this.youtubePlayerView.render().el)
      this.$('.player-container').html(this.subtitlesScrollerView.render().el)
      this.$('.controls-container').html(this.subtitlesControlsView.render().el)
      this.$('.dictionaryContainer').html(this.dictionaryView.render().el)

      return this

  )

  return YoutubeMainView