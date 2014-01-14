define [
  'jrdio',
  'backbone'
], (Jrdio, Backbone) ->

  RdioPlayer = Backbone.Model.extend(
    defaults:
      settings: {}
      ready: false
      syncTo: 0
      currentSong: null
      newSong: true

    initialize: () ->
      this.seeking = null

      this.listenTo(this, 'change:currentSong', () =>
        this.set(
          newSong: true
        )
      )

      $(document).ready(() =>
        $('#api').bind('positionChanged.rdio', (e, position) =>
          position = position * 1000

          # Rdio sends errant signals sometimes
          console.log('RDIO SYNC SEEKING: ' + this.seeking)
          if this.seeking? and position is not this.seeking
            console.log('RDIO IGNORE ERRANT SIGNAL')
            return

          this.seeking = null

          if this.get('settings').get('enableLogging')
            console.log('RDIO SYNC MESSAGE: ' + position)

          this.set(
            syncTo: position
          )
        )

        $('#api').bind('ready.rdio', () =>
          if this.get('settings').get('enableLogging')
            console.log('RDIO READY')

          this.set(
            ready: true
          )
        )

        $.ajax(
          type: 'GET'
          url: '/api/rdio/getPlaybackToken'
          success: (token) =>
            $('#api').rdio(token)
        )
      )

    play: (callback) ->
      rdio = $('#api').rdio()
      currentSong = this.get('currentSong')
      if this.get('ready') and rdio and currentSong? and currentSong.key?
        if this.get('newSong')
          if this.get('settings').get('enableLogging')
            console.log('RdioPlayer: PLAY NEW SONG: key: ' + currentSong.key)
          rdio.play(currentSong.key)
          this.set(
            newSong: false
          )
        else
          if this.get('settings').get('enableLogging')
            console.log('RdioPlayer: RESUME SONG')
          rdio.play()

    pause: () ->
      rdio = $('#api').rdio()
      if this.get('ready') and rdio
        if this.get('settings').get('enableLogging')
          console.log('RdioPlayer: PAUSE')
        rdio.pause()

    seek: (trackPosition, callback) ->
      rdio = $('#api').rdio()
      if this.get('ready') and rdio
        if this.get('settings').get('enableLogging')
          console.log('RdioPlayer: SEEK: ' + trackPosition)
        rdio.seek(trackPosition/1000)
        this.seeking = trackPosition

  )

  return RdioPlayer