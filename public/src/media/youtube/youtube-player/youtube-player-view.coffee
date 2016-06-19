define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  YoutubePlayerView = Backbone.View.extend(
    tagName:  'div'
    className: 'video-player'
    
    initialize: () ->
      this.playerId = 'ytPlayer'

    render: () ->
      this.$el.html(Handlebars.templates['youtube-player'](this.model.toJSON()))

      postRender = () =>
        this.postRender()
      setTimeout(postRender)

      return this

    postRender: () ->
      onReady = (event) =>
        this.model.ytPlayer = event.target
        console.log('YT player ready')
        this.model.set(
          ytPlayerReady: true
        )

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
          videoId: this.model.get('currentSong')?.youtubeKey
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
        new YT.Player(this.playerId, params)

      if typeof(YT) == 'undefined' || typeof(YT.Player) == 'undefined'
        window.onYouTubeIframeAPIReady = onAPIReady
        $.getScript('https://www.youtube.com/iframe_api')
      else
        onAPIReady()

      


  )

  return YoutubePlayerView