define [
  'subtitles.controls.view'
  'backbone',
  'handlebars',
  'templates'
], (SubtitlesControlsView, Backbone, Handlebars) ->
  YoutubePlayerView = Backbone.View.extend(
    tagName:  'div'
    className: 'video-player'
    
    initialize: () ->
      this.playerId = 'ytPlayer'

      this.subtitlesControlsView = new SubtitlesControlsView(
        model: this.model
        allowHideTranslation: true
      )

      this.subtitlesControlsView.on('enterPresentationMode', () =>
        this.trigger('enterPresentationMode')
        this.calculateYTPlayerHeight()
      )
      this.subtitlesControlsView.on('leavePresentationMode', () =>
        this.trigger('leavePresentationMode')
        this.calculateYTPlayerHeight()
      )
      this.subtitlesControlsView.on('hideVideo', () =>
        this.$('.video-container').hide()
      )
      this.subtitlesControlsView.on('showVideo', () =>
        this.$('.video-container').show()
      )
      this.subtitlesControlsView.on('hideTranslation', () =>
        $('.translated-subtitle').css('visibility', 'hidden')
      )
      this.subtitlesControlsView.on('showTranslation', () =>
        $('.translated-subtitle').css('visibility', 'visible')
      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-player'](this.model.toJSON()))
      this.$('.controls-container').html(this.subtitlesControlsView.render().el)
      
      postRender = () =>
        this.postRender()
      setTimeout(postRender)

      return this

    calculateYTPlayerHeight: () ->
      ytPlayerWidth = this.$('#' + this.playerId).width()
      ytPlayerHeight = ytPlayerWidth * 0.75
      this.$('#' + this.playerId).height(ytPlayerHeight + 'px')

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

      if typeof(YT) == 'undefined' || typeof(YT.Player) == 'undefined'
        window.onYouTubeIframeAPIReady = onAPIReady
        $.getScript('//www.youtube.com/iframe_api?noext')
      else
        onAPIReady()
  )

  return YoutubePlayerView