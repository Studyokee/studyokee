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
        liElement = $(this).parent('li')
        index = liElement.attr('data-index')
        liElement.find('.original-subtitle').hide()
        liElement.find('.updateLine').show()
        liElement.find('.toAdd').focus()
        liElement.find('.toAdd').val(liElement.find('.subtitle-text').html())

        wireInput = () =>
          if liElement.attr('data-wired')
            return

          replaceLine = () =>
            text = liElement.find('.toAdd').val()
            if text?.length > 0
              view.model.splice(view.model.get('i'), 1, text)

          liElement.find('.toAdd').keydown((event) =>
            if event.which is 13
              replaceLine()
              event.preventDefault()
          )
          liElement.find('.toAdd').keyup((event) =>
            if liElement.find('.toAdd').val()
              liElement.find('.addLine').removeClass('btn-default')
              liElement.find('.addLine').addClass('btn-primary')
            else
              liElement.find('.addLine').removeClass('btn-primary')
              liElement.find('.addLine').addClass('btn-default')
          )
          liElement.find('.addLine').on('click', replaceLine)
          liElement.attr('data-wired', true)

        wireInput()

        view.model.pause()
      )


      this.$('.remove').on('click', () ->
        index = $(this).parent('li').attr('data-index')
        view.model.removeLine(index)
      )

      insertBefore = this.$('.insertBefore')
      insertTextBefore = () =>
        text = insertBefore.find('.toAdd').val()
        if text?.length > 0
          view.model.splice(view.model.get('i'), 0, text)

      insertBefore.find('.toAdd').keydown((event) =>
        if event.which is 13
          insertTextBefore()
          event.preventDefault()
      )
      insertBefore.find('.toAdd').keyup((event) =>
        if insertBefore.find('.toAdd').val()
          insertBefore.find('.addLine').removeClass('btn-default')
          insertBefore.find('.addLine').addClass('btn-primary')
        else
          insertBefore.find('.addLine').removeClass('btn-primary')
          insertBefore.find('.addLine').addClass('btn-default')
      )
      insertBefore.find('.openInsert').on('click', () =>
        insertBefore.find('.openInsert').hide()
        insertBefore.find('.insertLine').show()
        insertBefore.find('.toAdd').focus()
      )
      insertBefore.find('.addLine').on('click', insertTextBefore)

      insertAfter = this.$('.insertAfter')
      insertTextAfter = () =>
        text = insertAfter.find('.toAdd').val()
        if text?.length > 0
          view.model.splice(view.model.get('i') + 1, 0, text)

      insertAfter.find('.toAdd').keydown((event) =>
        if event.which is 13
          insertTextAfter()
          event.preventDefault()
      )
      insertAfter.find('.toAdd').keyup((event) =>
        if insertAfter.find('.toAdd').val()
          insertAfter.find('.addLine').removeClass('btn-default')
          insertAfter.find('.addLine').addClass('btn-primary')
        else
          insertAfter.find('.addLine').removeClass('btn-primary')
          insertAfter.find('.addLine').addClass('btn-default')
      )
      insertAfter.find('.openInsert').on('click', () =>
        insertAfter.find('.openInsert').hide()
        insertAfter.find('.insertLine').show()
        insertAfter.find('.toAdd').focus()
      )
      insertAfter.find('.addLine').on('click', insertTextAfter)

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