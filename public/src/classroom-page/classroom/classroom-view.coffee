define [
  'media.item.list.view',
  'dictionary.view',
  'subtitles.scroller.view',
  'subtitles.controls.view'
  'youtube.player.view',
  'backbone',
  'handlebars',
  'templates'
], (MenuView, DictionaryView, SubtitlesScrollerView, SubtitlesControlsView, YoutubePlayerView, Backbone, Handlebars) ->
  
  ClassroomView = Backbone.View.extend(

    initialize: () ->
      this.menuView = new MenuView(
        model: this.model.menuModel
        allowSelect: true
      )
      this.subtitlesControlsView = new SubtitlesControlsView(
        model: this.model.youtubePlayerModel
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

      this.menuView.on('select', (item) =>
        console.log('ClassroomView: update current song')
        window.location.hash = '#' + item.title
        this.model.set(
          currentSong: item.song
        )
      )

      this.subtitlesControlsView.on('toggleTranslation', () =>
        this.subtitlesScrollerView.trigger('toggleTranslation')
      )

      this.subtitlesScrollerView.on('lookup', (query) =>
        this.model.dictionaryModel.set(
          query: query
        )
        this.model.youtubePlayerModel.pause()
        $('.dictionaryContainerWrapper').show()
      )

    render: () ->
      this.$el.html(Handlebars.templates['classroom'](this.model.toJSON()))

      this.$('.mediaItemListContainer').html(this.menuView.render().el)
      this.$('.video-player-container').html(this.youtubePlayerView.render().el)
      this.$('.player-container').html(this.subtitlesScrollerView.render().el)
      this.$('.controls-container').html(this.subtitlesControlsView.render().el)
      this.$('.dictionaryContainer').html(this.dictionaryView.render().el)

      $('.dictionaryContainerWrapper > .close').click(() ->
        $('.dictionaryContainerWrapper').hide()
      )

      user = this.model.get('settings').get('user')
      if user.admin is 'true' || this.model.get('classroom')?.createdById is user.id
        $('.editClassroomButton').show()

      return this
  )

  return ClassroomView