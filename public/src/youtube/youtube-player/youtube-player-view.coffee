define [
  'backbone',
  'handlebars',
  'swfobject',
  'templates'
], (Backbone, Handlebars, SwfObject) ->
  YoutubePlayerView = Backbone.View.extend(
    tagName:  'div'
    className: 'videoPlayer'
    id: 'videoPlayer'
    
    initialize: () ->
      this.playerId = 'ytPlayer'

    render: () ->
      fn = () =>
        this.loadPlayer()
      setTimeout(fn)

      return this

    loadPlayer: () ->
      params =
        allowScriptAccess: 'always'
      atts =
        id: this.playerId

      width = this.$el.width()
      height = this.$el.height()

      SwfObject.embedSWF('https://www.youtube.com/apiplayer?' +
       'version=3&enablejsapi=1&playerapiid=player1',
       this.id, width, height, '9', null, null, params, atts)
  )

  # This is automatically called by the player once it loads
  window.onYouTubePlayerReady = () ->
    setInterval(updatePlayerInfo, 250)
    updatePlayerInfo()
    $('#' + this.playerId).cueVideoById('ylLzyHk54Z0')

  return YoutubePlayerView