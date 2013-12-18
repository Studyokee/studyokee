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
    timer: null

    initialize: () ->
      this.enableTooling = true

      this.listenTo(this, 'change:currentSong', () =>
        if this.enableTooling
          console.log('SUBITLES PLAYER: change currentSong')
        this.pause()
        this.getSubtitles()
        this.set(
          i: 0
        )
      )

    getSubtitles: () ->
      this.set(
        isLoading: true
      )

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
      
      toLanguage = this.get('toLanguage')
      dataProvider = this.get('dataProvider')
      dataProvider.getSegments(id, toLanguage, callback)

    play: () ->
      musicPlayer = this.get('musicPlayer')
      currentSong = this.get('currentSong')
      musicPlayer.play(currentSong)
      this.startTimer(0)

    pause: () ->
      musicPlayer = this.get('musicPlayer')
      musicPlayer.pause()
      this.clearTimer()

    next: () ->
      subtitles = this.get('subtitles').original
      i = this.get('i') + 1
      if subtitles[i]?
        this.set(
          i: i
        )
        this.startTimer(subtitles[i].ts)
        this.get('musicPlayer').seek(subtitles[i].ts)

    prev: () ->
      subtitles = this.get('subtitles').original
      i = this.get('i')

      currentTime = this.get('musicPlayer').getTrackPosition()
      currentIndexStart = subtitles[i].ts

      if i isnt 0 and (currentTime - currentIndexStart) < 100
        i--

      if i >= 0
        this.set(
          i: i
        )
        this.startTimer(subtitles[i].ts)
        this.get('musicPlayer').seek(subtitles[i].ts)

    clearTimer: () ->
      if this.enableTooling
        console.log('SUBITLES PLAYER: clearTimer')
      clearTimeout(this.timer)

    startTimer: (ts) ->
      this.clearTimer()
      subtitles = this.get('subtitles').original
      i = this.get('i') + 1

      if subtitles[i]?
        nextTs = subtitles[i].ts
        wait = nextTs - (ts)
        if this.enableTooling
          console.log('SUBITLES PLAYER: startTimer: ts: ' + ts + ', nextTs: ' + nextTs + ', i: ' + i)

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