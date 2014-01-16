define [
  'backbone',
  'subtitles.scroller.view',
  'music.player',
  'handlebars',
  'templates'
], (Backbone, SubtitlesScrollerView, MusicPlayer, Handlebars) ->

  SubtitlesSyncView = Backbone.View.extend(
    tagName:  "div"
    className: "sync"

    initialize: () ->
      this.musicPlayer = new MusicPlayer(
        currentSong:
          key: this.model.get('id')
      )

      this.lastMeasurement = null
      this.position = 0
      this.listenTo(this.musicPlayer, 'change:syncTo', () =>
        this.position = this.musicPlayer.get('syncTo')
        this.lastMeasurement = new Date().getTime()
      )

      this.scrollerModel = new Backbone.Model(
        subtitles: this.model.get('subtitles')
        i: 0
        showTimestamps: true
      )
      this.listenTo(this.model, 'change:subtitles', () =>
        this.scrollerModel.set(
          subtitles: this.model.get('subtitles')
          i: 0
        )
      )

      this.scrollerView = new SubtitlesScrollerView(
        model: this.scrollerModel
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-sync']())

      this.$('.syncScroller').append(this.scrollerView.render().el)

      # Activate buttons
      this.$('.syncPlay').on('click', () =>
        this.musicPlayer.play()
      )
      this.$('.syncNext').on('click', () =>
        this.next()
      )
      this.$('.syncPrev').on('click', () =>
        this.prev()
      )
      this.$('.save').on('click', () =>
        this.saveSubtitles()
      )
      # this.$('.setI').on('keyup', (event) =>
      #   val = this.$(event.target).val()
      #   if not val?
      #     return
      #   i = parseInt(val)
      #   this.scrollerModel.set(
      #     i: i
      #   )
      #   subtitles = this.model.get('subtitles').original
      #   current = subtitles[i]
      #   if current?
      #     this.musicPlayer.seek(current.ts)
      # )

      return this

    next: () ->
      subtitles = this.model.get('subtitles')
      originalSubtitles = subtitles.original
      currentIndex = this.scrollerModel.get('i')
      currentIndex++

      if originalSubtitles[currentIndex]?
        diff = new Date().getTime() - this.lastMeasurement
        ts = this.position + diff
        console.log('ts: ' + ts)
        if originalSubtitles[currentIndex]?
          originalSubtitles[currentIndex].ts = ts
        
        this.scrollerModel.set(
          i: currentIndex
        )
        this.scrollerModel.trigger('change:subtitles')

    prev: () ->
      scrollerModel = this.model.get('scrollerModel')
      currentIndex = scrollerModel.get('i')

      if currentIndex > 0
        currentIndex--
        scrollerModel.set(
          i: currentIndex
        )

      originalSubtitles = this.model.get('subtitles').original
      this.musicPlayer.seek(originalSubtitles[currentIndex].ts)
      
    saveSubtitles: () ->
      original = this.model.get('subtitles').original

      prev = 0
      for line in original
        if line.ts is 0 and prev isnt 0
          line.ts = prev
        prev = line.ts

      this.trigger('save', original)
  )

  return SubtitlesSyncView