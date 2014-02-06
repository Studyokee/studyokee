define [
  'subtitles.controls.view'
  'backbone',
  'handlebars',
  'swfobject',
  'yt',
  'templates'
], (SubtitlesControlsView, Backbone, Handlebars, SwfObject, YT) ->
  YoutubePlayerView = Backbone.View.extend(
    tagName:  'div'
    className: 'videoPlayer'
    
    initialize: () ->
      this.playerId = 'ytPlayer'

      this.subtitlesControlsView = new SubtitlesControlsView(
        model: this.model
      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-player']())
      this.$('.controlsContainer').html(this.subtitlesControlsView.render().el)

      onReady = () =>
        this.model.onChangeSong()

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

      return this
  )

  return YoutubePlayerView