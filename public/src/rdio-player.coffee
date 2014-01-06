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
      playing: false
      ready: false
      lastPositionMeasurement: null
      positionChangedTick: null

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
            if this.get('settings').get('enableLogging')
              console.log('RDIO POSITION CHANGE: ' + position)

            this.set(
              position: position
              lastPositionMeasurement: new Date().getTime()
            )
          )
          $('#api').bind('playStateChanged.rdio', (e, playState) =>
            if this.get('settings').get('enableLogging')
              console.log('RDIO PLAYSTATE CHANGE: ' + playState)

            if playState is 1
              this.startPlaying()
            else
              this.stopPlaying()
          )
        )
        
      )

    startPlaying: () ->
      this.notifyPositionChanged()
      clearTimeout(this.get('positionChangedTick'))
      this.set(
        playing: true
        positionChangedTick: setTimeout(fn, 500)
      )

    stopPlaying: () ->
      clearTimeout(this.get('positionChangedTick'))

      this.set(
        playing: false
        position: this.getTrackPosition()
      )

    getTrackPosition: () ->
      position = null
      if this.get('playing')
        currentTime = new Date().getTime()
        diff = (currentTime - this.get('lastPositionMeasurement'))/1000

        if this.get('settings').get('enableLogging')
          console.log('RdioPlayer: getTrackPosition: MEASURED DIFF: ' + diff)
        
        position = this.get('position') + diff
      else
        position = this.get('position')

      if this.get('settings').get('enableLogging')
        console.log('RdioPlayer: getTrackPosition: ' + position)

      return position * 1000

    notifyPositionChanged: () ->
      position = this.getTrackPosition()

      if this.get('settings').get('enableLogging')
        console.log('RdioPlayer: notifyPositionChanged: position: ' + position)
        
      for callback in this.get('listeners').positionChanged
        callback(position)

    play: (song) ->
      rdio = $('#api').rdio()
      if this.get('ready') and rdio
        if this.get('settings').get('enableLogging')
          console.log('RdioPlayer: PLAY: key: ' + song.key)
        rdio.play(song.key)

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
          console.log('RdioPlayer: SEEK: ' + trackPosition/1000)
        rdio.seek(trackPosition/1000)
        this.stopPlaying()

    changeSong: (song) ->
      if this.get('settings').get('enableLogging')
        console.log('artist: ' + artist + ' song: ' + song)
      this.set(
        currentSong: song
      )

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