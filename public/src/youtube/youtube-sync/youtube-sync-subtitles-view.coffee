define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  YoutubeSyncSubtitlesView = Backbone.View.extend(
    className: 'youtube-sync-subtitles'
    pageSize: 1
    
    initialize: () ->
      this.listenTo(this.model, 'change:i', () =>
        this.onPositionChange()
      )
      this.on('sizeChange', () =>
        this.onPositionChange()
      )
      this.listenTo(this.model, 'updateSubtitles', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['youtube-sync-subtitles'](this.model.toJSON().currentSong))

      view = this
      this.$('.edit').on('click', () ->
        index = $(this).parent('li').attr('data-index')
        console.log('edit ' + index)
        view.model.pause()
      )
      this.$('.remove').on('click', () ->
        index = $(this).parent('li').attr('data-index')
        view.model.removeLine(index)
      )

      this.$('.insertBefore .openInsert').on('click', () =>
        this.$('.insertBefore .openInsert').hide()
        this.$('.insertBefore .insertLine').show()
      )
      this.$('.insertBefore .addLine').on('click', () =>
        text = this.$('.insertBefore .toAdd').val()
        if text?.length > 0
          this.model.insertLine(this.model.get('i'), text)
      )
      this.$('.insertAfter .openInsert').on('click', () =>
        this.$('.insertAfter .openInsert').hide()
        this.$('.insertAfter .insertLine').show()
      )
      this.$('.insertAfter .addLine').on('click', () =>
        text = this.$('.insertAfter .toAdd').val()
        if text?.length > 0
          this.model.insertLine(this.model.get('i') + 1, text)
      )

      this.onPositionChange()

      return this

    getLength: () ->
      subtitles = this.model.get('currentSong')?.subtitles
      if subtitles
        return subtitles.length
      else
        return 0

    onPositionChange: () ->
      i = this.model.get('i')
      length = this.getLength()
      if i >= length
        i = length - 1
      if i < 0
        i = 0

      this.shiftPage(i)
      this.selectLine(i)

    shiftPage: (i) ->
      this.lineHeight = this.$('li.subtitle').outerHeight(true)
      page = Math.floor(i/this.pageSize)
      if page isnt 0
        page--
      topMargin = -(page * (this.pageSize * this.lineHeight))
      this.$('.subtitles').css('margin-top', topMargin + 'px')

    selectLine: (i) ->
      insertBeforeButton = this.$('.insertBefore')
      insertAfterButton = this.$('.insertAfter')
      this.$('.subtitles .subtitle').each((index, el) ->
        if index is i
          insertBeforeButton.insertBefore(el)
          insertAfterButton.insertAfter(el)
          $(el).addClass('active')
        else
          $(el).removeClass('active')
      )
  )

  return YoutubeSyncSubtitlesView