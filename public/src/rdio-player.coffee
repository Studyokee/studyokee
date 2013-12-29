define [
  'jrdio',
  'underscore'
], (Jrdio, _) ->
  ####################################################################
  # Interface:
  # function MusicPlayer() {
  #      this.getTrackName()
  #      this.getTrackPosition()
  #      this.isPlaying()
  # }
  ####################################################################

  class RdioPlayer

    constructor: (@settings) ->
      @artist = null
      @song = null

      @ready = false
      @playing = false

      @position = 0
      @lastPositionMeasurement = new Date().getTime()
      @listeners =
        positionChanged: []
      @positionChangedTick = null

      $(document).ready(() =>
        $('#api').bind('ready.rdio', () =>
          if @settings.get('enableLogging')
            console.log('RDIO READY')

          @ready = true
        )
        this.getPlaybackToken((token) =>
          $('#api').rdio(token)
          $('#api').bind('positionChanged.rdio', (e, position) =>
            if @settings.get('enableLogging')
              console.log('RDIO POSITION CHANGE: ' + position)

            @position = position
            @lastPositionMeasurement = new Date().getTime()
          )
          $('#api').bind('playStateChanged.rdio', (e, playState) =>
            if @settings.get('enableLogging')
              console.log('RDIO PLAYSTATE CHANGE: ' + playState)

            if playState is 1
              this.startPlaying()
            else
              this.stopPlaying()
          )
        )
        
      )

    startPlaying: () ->
      @playing = true
      @lastPositionMeasurement = new Date().getTime()

      fn = () =>
        this.notifyPositionChanged()
        clearTimeout(@positionChangedTick)
        @positionChangedTick = setTimeout(fn, 500)

      fn()

    stopPlaying: () ->
      @position = this.getTrackPosition()
      clearTimeout(@positionChangedTick)

      @playing = false

    getTrackPosition: () ->
      position = null
      if @playing
        currentTime = new Date().getTime()
        diff = (currentTime - @lastPositionMeasurement)/1000

        if @settings.get('enableLogging')
          console.log('RdioPlayer: getTrackPosition: MEASURED DIFF: ' + diff)
        
        position = @position + diff
      else
        position = @position

      if @enableTooling
        console.log('RdioPlayer: getTrackPosition: ' + position)

      return position * 1000

    isPlaying: () ->
      return @playing

    notifyPositionChanged: () ->
      position = this.getTrackPosition()

      if @settings.get('enableLogging')
        console.log('RdioPlayer: notifyPositionChanged: position: ' + position)
        
      for callback in @listeners.positionChanged
        callback(position)

    play: (song) ->
      rdio = $('#api').rdio()
      if @ready and rdio
        if @settings.get('enableLogging')
          console.log('RdioPlayer: PLAY: key: ' + song.key)
        rdio.play(song.key)

    pause: () ->
      if @settings.get('enableLogging')
        console.log('RdioPlayer: PAUSE')

      rdio = $('#api').rdio()
      if @ready and rdio
        rdio.pause()

    seek: (trackPosition) ->
      rdio = $('#api').rdio()
      if @ready and rdio
        if @settings.get('enableLogging')
          console.log('RdioPlayer: SEEK: ' + trackPosition/1000)
        rdio.seek(trackPosition/1000)
        this.stopPlaying()

    onPositionChange: (callback) ->
      @listeners.positionChanged.push(callback)

    changeSong: (artist, song) ->
      if @settings.get('enableLogging')
        console.log('artist: ' + artist + ' song: ' + song)
      @artist = artist
      @song = song
      listener(artist, song) for listener in @listeners.songChange

    search: (query, callback) ->
      if not query? or query is ''
        return

      if @settings.get('enableLogging')
        console.log('RdioPlayer: search: ' + query)

      @lastSearch = query
      $.ajax(
        type: 'GET'
        url: '/api/rdio/search/' + query
        success: (data) =>
          if query isnt @lastSearch
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

  return RdioPlayer