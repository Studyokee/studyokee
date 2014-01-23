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

      window.onYouTubePlayerReady = () =>
        this.model.ytPlayer = $('#' + this.playerId)[0]
        this.model.onChangeSong()

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

      height = this.$el.height()
      width = height * (4/3)

      SwfObject.embedSWF('https://www.youtube.com/apiplayer?' +
       'version=3&enablejsapi=1&playerapiid=player1',
       this.id, width, height, '9', null, null, params, atts)
  )

  return YoutubePlayerView