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

    constructor: () ->
      @enableLogging = true

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
          if @enableLogging
            console.log('RDIO READY')

          @ready = true
        )
        $('#api').rdio('GAlSWrxf_____zk4ZmdtbjVyeGU5dnU3aHRxNTJ1ZXkyYWxvY2FsaG9zdLdC0PEcjVgFr9fwe2O80JE=')
        $('#api').bind('positionChanged.rdio', (e, position) =>
          if @enableLogging
            console.log('RDIO POSITION CHANGE: ' + position)

          @position = position
          @lastPositionMeasurement = new Date().getTime()
        )
        $('#api').bind('playStateChanged.rdio', (e, playState) =>
          if @enableLogging
            console.log('RDIO PLAYSTATE CHANGE: ' + playState)

          if playState is 1
            this.startPlaying()
          else
            this.stopPlaying()
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

        if @enableLogging
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

      if @enableLogging
        console.log('RdioPlayer: notifyPositionChanged: position: ' + position)
        
      for callback in @listeners.positionChanged
        callback(position)

    play: (song) ->
      rdio = $('#api').rdio()
      if @ready and rdio
        if @enableLogging
          console.log('RdioPlayer: PLAY: key: ' + song.key)
        rdio.play(song.key)

    pause: () ->
      if @enableLogging
        console.log('RdioPlayer: PAUSE')

      rdio = $('#api').rdio()
      if @ready and rdio
        rdio.pause()

    seek: (trackPosition) ->
      rdio = $('#api').rdio()
      if @ready and rdio
        if @enableLogging
          console.log('RdioPlayer: SEEK: ' + trackPosition/1000)
        rdio.seek(trackPosition/1000)
        this.stopPlaying()

    onPositionChange: (callback) ->
      @listeners.positionChanged.push(callback)

    changeSong: (artist, song) ->
      console.log('artist: ' + artist + ' song: ' + song)
      @artist = artist
      @song = song
      listener(artist, song) for listener in @listeners.songChange

    search: (query, callback) ->
      if not query? or query is ''
        return

      console.log('RdioPlayer: search: ' + query)

      @lastSearch = query
      $.ajax(
        type: 'GET'
        url: 'http://localhost:3000/api/search/' + query
        success: (data) =>
          if query isnt @lastSearch
            return

          results = $.parseJSON(data).result.results
          callback(results)
      )

  return RdioPlayer