define [
  'backbone'
], (Backbone) ->

  ####################################################################
  #
  # SubtitlesPlayerModel
  #
  # The model for the collection of original subtitles, translated
  # subtitles, controls, and dictionary lookup
  #
  ####################################################################
  SubtitlesPlayerModel = Backbone.Model.extend(
    defaults:
      i: 0
      subtitles:
        original: []
        translation: []
      enableKeyboard: true
      isPlaying: false
    timer: null

    initialize: () ->
      this.listenTo(this, 'change:currentSong', () =>
        if this.get('enableLogging')
          console.log('SUBITLES PLAYER: change currentSong')
        this.pause()
        this.getSubtitles()
        this.set(
          i: 0
        )
      )

      this.get('musicPlayer').onPositionChange((ts) =>
        this.startTimer(ts)
      )

    getSubtitles: () ->
      currentSong = this.get('currentSong')
      if not currentSong?
        this.set(
          subtitles: {}
        )
        return
      
      id = currentSong.key
      @lastCallbackId = id

      callback = (subtitles) =>
        if @lastCallbackId is id
          this.set(
            subtitles: subtitles
            isLoading: false
          )
      
      this.set(
        isLoading: true
      )

      toLanguage = this.get('toLanguage')
      dataProvider = this.get('dataProvider')
      dataProvider.getSegments(id, toLanguage, callback)

    play: () ->
      this.set(
        isPlaying: true
      )
      musicPlayer = this.get('musicPlayer')
      currentSong = this.get('currentSong')
      musicPlayer.play(currentSong)

    pause: () ->
      this.set(
        isPlaying: false
      )
      musicPlayer = this.get('musicPlayer')
      musicPlayer.pause()
      this.clearTimer()

    next: () ->
      subtitles = this.get('subtitles').original
      i = this.get('i') + 1
      if subtitles[i]?
        this.clearTimer()
        if this.get('enableLogging')
          console.log('Set index to: ' + i + ' and time to: ' + subtitles[i].ts)
        this.set(
          i: i
        )
        this.get('musicPlayer').seek(subtitles[i].ts)

    prev: () ->
      subtitles = this.get('subtitles').original
      i = this.get('i')

      if i isnt 0
        i--

      if i >= 0
        this.clearTimer()
        if this.get('enableLogging')
          console.log('Set index to: ' + i + ' and time to: ' + subtitles[i].ts)
        this.set(
          i: i
        )
        this.get('musicPlayer').seek(subtitles[i].ts)

    clearTimer: () ->
      if this.get('enableLogging')
        console.log('SUBITLES PLAYER: clearTimer')
      clearTimeout(this.timer)

    startTimer: (ts) ->
      this.clearTimer()
      subtitles = this.get('subtitles').original
      i = this.get('i') + 1

      if subtitles[i]?
        nextTs = subtitles[i].ts
        wait = nextTs - ts
        if this.get('enableLogging')
          console.log('SUBITLES PLAYER: startTimer: ts: ' + ts + ', nextTs: ' + nextTs + ', wait: ' + wait + ', i: ' + (i-1))

        next = () =>
          this.set(
            i: i
          )
          # Adjust to actual track position
          nextTs = this.get('musicPlayer').getTrackPosition()
          this.startTimer(nextTs)
        
        this.timer = setTimeout(next, wait)

  )

  return SubtitlesPlayerModel