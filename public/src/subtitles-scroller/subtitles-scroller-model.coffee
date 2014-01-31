define [
  'backbone'
], (Backbone) ->
  SubtitlesScrollerModel = Backbone.Model.extend(
    default:
      subtitles: []
      translation: []
      i: 0
      isLoading: true

    initialize: () ->
      this.timer = null

      this.listenTo(this, 'change:subtitles', () =>
        this.set(
          i: 0
        )
      )

    play: (ts) ->
      console.log('SCROLLER PLAY: ' + ts)
      this.setTimer(ts)

    pause: () ->
      console.log('SCROLLER PAUSE')
      this.clearTimer()

    setTimer: (ts) ->
      console.log('SCROLLER TIMER: ' + ts)
      this.clearTimer()
      subtitles = this.get('subtitles')
      this.set(
        i: this.getPosition(ts)
      )
      nextIndex = this.get('i') + 1

      if subtitles?[nextIndex]?
        nextTs = subtitles[nextIndex].ts
        diff = nextTs - ts

        console.log('nextTs: ' + nextTs)
        console.log('ts: ' + ts)
        console.log('Set timeout for: ' + diff)

        next = () =>
          this.setTimer(nextTs)
        this.timer = setTimeout(next, diff)

    clearTimer: () ->
      clearTimeout(this.timer)

    getPosition: (ts) ->
      subtitles = this.get('subtitles')
      if not ts? or not subtitles? or subtitles.length is 0
        return null

      i = 0
      while (i <= subtitles.length - 1) and subtitles[i].ts <= ts
        i++

      position = Math.max(i-1, 0)
      console.log('position: ' + position)
      return position

  )

  return SubtitlesScrollerModel