define [
  'jrdio',
  'underscore',
  'backbone'
], (Jrdio, _, Backbone) ->

  RdioPlayer = Backbone.Model.extend(
    defaults:
      settings: {}
      position: 0
      currentSong: null
      newSong: true
      playing: false
      ready: false

    initialize: () ->
      $(document).ready(() =>
        $('#api').bind('ready.rdio', () =>
          if this.get('settings').get('enableLogging')
            console.log('RDIO READY')

          this.set(
            'ready': true
          )
        )
        this.getPlaybackToken((token) =>
          $('#api').rdio(token)
          $('#api').bind('positionChanged.rdio', (e, position) =>
            position = position * 1000
            if this.get('settings').get('enableLogging')
              console.log('RDIO POSITION CHANGE: ' + position)

            this.set(
              position: position
            )
          )
          $('#api').bind('playStateChanged.rdio', (e, playState) =>
            if this.get('settings').get('enableLogging')
              console.log('RDIO PLAYSTATE CHANGE: ' + playState)

            this.set(
              playing: playState is 1
            )
          )
        )
      )

      this.listenTo(this, 'change:currentSong', () =>
        this.set(
          newSong: true
        )
      )

    getTrackPosition: () ->
      position = this.get('position')

      if this.get('settings').get('enableLogging')
        console.log('RdioPlayer: getTrackPosition: ' + position)

      return position

    play: () ->
      rdio = $('#api').rdio()
      currentSong = this.get('currentSong')
      if this.get('ready') and rdio
        if this.get('newSong')
          if currentSong?
            if this.get('settings').get('enableLogging')
              console.log('RdioPlayer: PLAY NEW SONG: key: ' + currentSong.key)
            rdio.play(currentSong.key)
            this.set(
              newSong: false
            )
        else
          if this.get('settings').get('enableLogging')
            console.log('RdioPlayer: RESUME SONG: key: ' + currentSong.key)
          rdio.play()

    pause: () ->
      if this.get('settings').get('enableLogging')
        console.log('RdioPlayer: PAUSE')

      rdio = $('#api').rdio()
      if this.get('ready') and rdio
        rdio.pause()

    seek: (trackPosition) ->
      rdio = $('#api').rdio()
      if this.get('ready') and rdio
        if this.get('settings').get('enableLogging')
          console.log('RdioPlayer: SEEK: ' + trackPosition)
        rdio.seek(trackPosition/1000)

    search: (query, callback) ->
      if not query? or query is ''
        return

      if this.get('settings').get('enableLogging')
        console.log('RdioPlayer: search: ' + query)

      this.set(
        lastSearch: query
      )
      $.ajax(
        type: 'GET'
        url: '/api/rdio/search/' + query
        success: (data) =>
          if query isnt this.get('lastSearch')
            return

          callback(data)
      )

    getPlaybackToken: (callback) ->
      $.ajax(
        type: 'GET'
        url: '/api/rdio/getPlaybackToken'
        success: (token) =>
          callback(token)
      )
  )

  return RdioPlayer