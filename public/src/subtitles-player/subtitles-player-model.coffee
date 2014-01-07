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
    timer: null

    initialize: () ->
      musicPlayer = this.get('musicPlayer')
      this.listenTo(musicPlayer, 'change:currentSong', () =>
        this.pause()
        this.getSubtitles(musicPlayer.get('currentSong'))
      )

      this.listenTo(musicPlayer, 'change:playing', () =>
        if musicPlayer.get('playing')
          this.start()
      )

      this.listenTo(musicPlayer, 'change:position', () =>
        if musicPlayer.get('playing')
          this.start()
      )

    getSubtitles: (currentSong) ->
      if not currentSong?
        this.set(
          subtitles: {}
        )
        return

      this.set(
        currentSong: currentSong
        isLoading: true
        playing: false
      )
      
      id = currentSong.key
      @lastCallbackId = id

      callback = (subtitles) =>
        if @lastCallbackId is id
          this.set(
            subtitles: subtitles
            isLoading: false
            i: 0
          )
      
      toLanguage = this.get('toLanguage')
      dataProvider = this.get('dataProvider')
      dataProvider.getSegments(id, toLanguage, callback)

    play: () ->
      this.set(
        playing: true
      )
      musicPlayer = this.get('musicPlayer')
      musicPlayer.play()

    pause: () ->
      this.set(
        playing: false
      )
      musicPlayer = this.get('musicPlayer')
      musicPlayer.pause()
      this.clearTimer()

    next: () ->
      original = this.get('subtitles').original
      if not original?
        return

      i = this.get('i') + 1
      if original[i]?
        this.clearTimer()
        if this.get('enableLogging')
          console.log('Set index to: ' + i + ' and time to: ' + original[i].ts)
        this.set(
          i: i
        )
        this.get('musicPlayer').seek(original[i].ts)

    prev: () ->
      original = this.get('subtitles').original
      if not original?
        return

      i = this.get('i')

      currentTime = this.get('musicPlayer').getTrackPosition()
      startOfSegment = original[i].ts
      diff = currentTime - startOfSegment

      if diff <= 1000 and i isnt 0
        i--

      if i >= 0 and original[i]?
        this.clearTimer()
        if this.get('enableLogging')
          console.log('Set index to: ' + i + ' and time to: ' + original[i].ts)
        this.set(
          i: i
        )
        this.get('musicPlayer').seek(original[i].ts)

    clearTimer: () ->
      if this.get('enableLogging')
        console.log('SUBITLES PLAYER: clearTimer')
      clearTimeout(this.timer)

    setTimer: (fn, wait) ->
      if this.get('enableLogging')
        console.log('SUBITLES PLAYER: setTimer for: ' + wait)
      this.timer = setTimeout(fn, wait)

    start: () ->
      ts = this.get('musicPlayer').getTrackPosition()
      this.clearTimer()
      original = this.get('subtitles').original
      i = this.get('i') + 1

      if original[i]?
        nextTs = original[i].ts
        wait = nextTs - ts
        if this.get('enableLogging')
          console.log('SUBITLES PLAYER: startTimer: ts: ' + ts + ', nextTs: ' + nextTs + ', wait: ' + wait + ', i: ' + (i-1))

        next = () =>
          this.set(
            i: i
          )
          this.start()
        
        this.setTimer(next, wait)

  )

  return SubtitlesPlayerModel