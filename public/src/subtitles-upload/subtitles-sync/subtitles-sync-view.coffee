define [
  'backbone',
  'subtitles.scroller.view',
  'handlebars',
  'templates'
], (Backbone, SubtitlesScrollerView, Handlebars) ->

  SubtitlesSyncView = Backbone.View.extend(
    tagName:  "div"
    className: "sync"

    initialize: () ->
      scrollerModel = new Backbone.Model(
        subtitles: this.model.get('subtitles')
        i: 0
      )

      this.model.set(
        scrollerModel: scrollerModel
      )

      this.scrollerView = new SubtitlesScrollerView(
        model: scrollerModel
        showTimestamps: true
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-sync']())

      this.$('.syncScroller').append(this.scrollerView.render().el)

      # Activate buttons
      this.$('.syncPlay').on('click', () =>
        this.model.get('musicPlayer').play(this.model.get('id'))
      )
      this.$('.syncPause').on('click', () =>
        this.model.get('musicPlayer').pause()
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

      return this

    next: () ->
      subtitles = this.model.get('subtitles')
      originalSubtitles = subtitles.original
      scrollerModel = this.model.get('scrollerModel')
      currentIndex = scrollerModel.get('i')
      currentIndex++

      if originalSubtitles[currentIndex]?
        ts = this.model.get('musicPlayer').getTrackPosition()
        console.log('ts: ' + ts)
        if originalSubtitles[currentIndex]?
          originalSubtitles[currentIndex].ts = ts
        
        scrollerModel.set(
          i: currentIndex
        )
        scrollerModel.trigger('change:subtitles')

    prev: () ->
      scrollerModel = this.model.get('scrollerModel')
      currentIndex = scrollerModel.get('i')

      if currentIndex > 0
        currentIndex--
        scrollerModel.set(
          i: currentIndex
        )

      originalSubtitles = this.model.get('subtitles').original
      this.model.get('musicPlayer').seek(originalSubtitles[currentIndex].ts)
      
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