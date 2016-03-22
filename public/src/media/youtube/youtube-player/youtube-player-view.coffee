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

    calculateYTPlayerHeight: () ->
      ytPlayerWidth = this.$('#' + this.playerId).width()
      ytPlayerHeight = ytPlayerWidth * 0.75
      this.$('#' + this.playerId).height(ytPlayerHeight + 'px')

    postRender: () ->
      onReady = () =>
        this.model.set(
          ytPlayerReady: true
        )
        this.model.trigger('cueSong')

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