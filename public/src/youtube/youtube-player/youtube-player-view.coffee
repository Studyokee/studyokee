define [
  'subtitles.controls.view'
  'backbone',
  'handlebars',
  'swfobject',
  'templates'
], (SubtitlesControlsView, Backbone, Handlebars, SwfObject) ->
  YoutubePlayerView = Backbone.View.extend(
    tagName:  'div'
    className: 'videoPlayer'
    
    initialize: () ->
      this.playerId = 'ytPlayer'

      this.subtitlesControlsView = new SubtitlesControlsView(
        model: this.model
      )

      window.onYouTubePlayerReady = () =>
        this.model.ytPlayer = $('#' + this.playerId)[0]
        this.model.onChangeSong()
        window.onPlayerStateChange = (state) =>
          fn = () =>
            this.model.onStateChange(state)
          setTimeout(fn)
        this.model.ytPlayer.addEventListener('onStateChange', 'onPlayerStateChange')

    render: () ->
      this.$el.html(Handlebars.templates['youtube-player']())

      this.$('.controlsContainer').html(this.subtitlesControlsView.render().el)

      fn = () =>
        this.loadPlayer()
      setTimeout(fn)

      return this

    loadPlayer: () ->
      params =
        allowScriptAccess: 'always'
      atts =
        id: this.playerId

      height = this.$el.height()
      width = height * (4/3)

      SwfObject.embedSWF('https://www.youtube.com/apiplayer?' +
       'version=3&enablejsapi=1&playerapiid=player1',
       'videoContainer', width, height, '9', null, null, params, atts)
  )

  return YoutubePlayerView