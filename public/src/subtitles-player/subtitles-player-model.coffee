define [
  'backbone',
  'music.player',
  'dictionary.model'
], (Backbone, MusicPlayer, DictionaryModel) ->

  SubtitlesPlayerModel = Backbone.Model.extend(
    defaults:
      i: 0
      subtitles:
        original: []
        translation: []
      currentSong: null
      playing: false
      settings: new Backbone.Model()
      prevPause: 1000

    initialize: () ->
      this.timer = null
      this.musicPlayer = this.get('musicPlayer')
      this.dictionaryModel = new DictionaryModel(
        fromLanguage: this.get('fromLanguage')
        toLanguage: this.get('toLanguage')
      )

      this.listenTo(this, 'change:currentSong', () =>
        this.pause()

        currentSong = this.get('currentSong')
        this.musicPlayer.set(
          currentSong: currentSong
        )
        this.getSubtitles(currentSong)
      )

      this.listenTo(this.musicPlayer, 'change:syncTo', () =>
        if this.get('playing')
          position = this.musicPlayer.get('syncTo')
          this.setPosition(position)
      )

    getSubtitles: (currentSong) ->
      if not currentSong?
        this.set(
          subtitles: {}
        )
        return

      this.set(
        isLoading: true
        lastCallbackId: currentSong.key
      )

      callback = (subtitles) =>
        if this.get('lastCallbackId') is currentSong.key
          this.set(
            isLoading: false
            subtitles: subtitles
            i: 0
            playing: false
          )
      
      this.get('dataProvider').getSegments(currentSong.key, this.get('toLanguage'), callback)

    play: () ->
      this.set(
        playing: true
      )
      this.musicPlayer.play()

    pause: () ->
      this.set(
        playing: false
      )
      this.musicPlayer.pause()
      this.clearTimer()

    next: () ->
      original = this.get('subtitles').original
      if not original?
        return

      i = this.get('i') + 1
      if original[i]?
        this.clearTimer()
        if this.get('settings').get('enableLogging')
          console.log('Set index to: ' + i + ' and time to: ' + original[i].ts)
        this.set(
          i: i
        )
        this.musicPlayer.seek(original[i].ts)

    prev: () ->
      original = this.get('subtitles').original
      if not original?
        return

      i = this.get('i')

      unset = () =>
        this.recentPrev = false
      setTimeout(unset, this.get('prevPause'))
      if i isnt 0 and (this.recentPrev or not this.get('playing'))
        i--
      this.recentPrev = true

      if i >= 0 and original[i]?
        this.clearTimer()
        if this.get('settings').get('enableLogging')
          console.log('Set index to: ' + i + ' and time to: ' + original[i].ts)
        this.set(
          i: i
        )
        this.musicPlayer.seek(original[i].ts)

    setPosition: (ts) ->
      this.clearTimer()
      original = this.get('subtitles').original

      i = this.getPosition(ts)
      if i?
        this.set(
          i: i
        )

        this.doOmptimisticTimer(ts)

    getPosition: (ts) ->
      original = this.get('subtitles').original
      if not ts? or not original? or original.length is 0
        return null

      i = 0
      while (i <= original.length - 1) and original[i].ts < ts
        i++

      return Math.max(i-1, 0)

    clearTimer: () ->
      if this.get('settings').get('enableLogging')
        console.log('SUBITLES PLAYER: clearTimer')
      clearTimeout(this.timer)

    setTimer: (fn, wait) ->
      if this.get('settings').get('enableLogging')
        console.log('SUBITLES PLAYER: optimistic timer engaged for: ' + wait)
      this.timer = setTimeout(fn, wait)

    doOmptimisticTimer: (ts) ->
      original = this.get('subtitles').original
      nextIndex = this.get('i') + 1

      if original[nextIndex]?
        nextTs = original[nextIndex].ts
        diff = nextTs - ts
        if diff < 1000
          next = () =>
            this.set(
              i: nextIndex
            )
          this.setTimer(next, diff)

    lookup: (query) ->
      this.dictionaryModel.set(
        query: query
      )

  )

  return SubtitlesPlayerModel