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

      this.menuView.on('select', (item) =>
        console.log('Classroom: update current song')
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
      console.log('ClassroomView: rerender')
      this.$el.html(Handlebars.templates['classroom'](this.model.toJSON()))

      this.$('.mediaItemListContainer').html(this.menuView.render().el)
      this.$('.video-player-container').html(this.youtubePlayerView.render().el)
      this.$('.player-container').html(this.subtitlesScrollerView.render().el)
      this.$('.controls-container').html(this.subtitlesControlsView.render().el)
      this.$('.dictionaryContainer').html(this.dictionaryView.render().el)

      ###this.$('.editClassroom').on('click', (e) =>
        Backbone.history.navigate('classrooms/' + this.model.get('data')?.classroomId + '/edit', {trigger: true})
        e.preventDefault()
      )
      #if (this.model.get('settings')?.get('user')?.id is this.model.get('data')?.createdById) or this.model.get('settings')?.get('user')?.admin?
      #  this.$('.editClassroom').show()
      ###

      $('.dictionaryContainerWrapper .close').click(() ->
        $('.dictionaryContainerWrapper').hide()
      )

      return this
  )

  return ClassroomView