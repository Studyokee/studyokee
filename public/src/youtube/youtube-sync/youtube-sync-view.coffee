define [
  'subtitles.controls.view',
  'youtube.sync.subtitles.view',
  'backbone',
  'handlebars',
  'yt',
  'templates'
], (SubtitlesControlsView, YoutubeSubtitlesSyncView, Backbone, Handlebars, YT) ->
  YoutubeSyncView = Backbone.View.extend(
    className: 'youtube-sync'
    
    initialize: () ->
      this.playerId = 'ytPlayer'

      this.subtitlesControlsView = new SubtitlesControlsView(
        model: this.model
        allowToggleVideo: true
      )
      this.youtubeSubtitlesSyncView = new YoutubeSubtitlesSyncView(
        model: this.model
      )

      this.subtitlesControlsView.on('hideVideo', () =>
        this.$('.video-container').hide()
      )
      this.subtitlesControlsView.on('showVideo', () =>
        this.$('.video-container').show()
      )

      this.listenTo(this.model, 'change:syncing', () =>
        this.renderSyncButton()
      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-sync'](this.model.toJSON()))
      this.$('.controls-container').html(this.subtitlesControlsView.render().el)
      this.$('.subtitles-container').html(this.youtubeSubtitlesSyncView.render().el)

      this.$('.toggleSync').on('click', () =>
        if this.model.get('syncing')
          this.model.set(
            syncing: false
          )
        else
          this.model.set(
            syncing: true
          )
      )

      this.renderSyncButton()

      postRender = () =>
        this.postRender()
      setTimeout(postRender)

      return this

    renderSyncButton: (syncing) ->
      toggleSync = this.$('.toggleSync')
      if this.model.get('syncing')
        toggleSync.addClass('btn-primary')
        toggleSync.removeClass('btn-default')
        toggleSync.attr('title', 'Turn Sync Off')
        toggleSync.html('Turn Sync Off')
      else
        toggleSync.removeClass('btn-primary')
        toggleSync.addClass('btn-default')
        toggleSync.attr('title', 'Turn Sync On')
        toggleSync.html('Turn Sync On')

    calculateYTPlayerHeight: () ->
      ytPlayerWidth = this.$('#ytPlayer').width()
      ytPlayerHeight = ytPlayerWidth * 0.75
      this.$('#ytPlayer').height(ytPlayerHeight + 'px')

    postRender: () ->
      onReady = () =>
        this.model.set(
          ytPlayerReady: true
        )
        this.model.trigger('change:currentSong')

      onStateChange = (state) =>
        fn = () =>
          this.model.onStateChange(state)
        setTimeout(fn)

      onAPIReady = () =>
        height = this.$el.height()
        width = height * (4/3)
        params =
          height: height
          width: width
          playerVars:
            modestbranding: 1
            fs: 0
            showInfo: 0
            rel: 0
            controls: 0
            # theme: 'light'
            # color: 'white'
          events:
            'onReady': onReady
            'onStateChange': onStateChange
        this.model.ytPlayer = new YT.Player(this.playerId, params)

      if YT?.loaded is 1
        onAPIReady()
      else
        window.onYouTubeIframeAPIReady = onAPIReady
  )

  return YoutubeSyncView