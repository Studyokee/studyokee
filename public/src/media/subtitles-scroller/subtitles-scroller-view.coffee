define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  ####################################################################
  #
  # SubtitlesScrollerView
  #
  # The view for a scrolling view of subtitles
  #
  ####################################################################
  SubtitlesScrollerView = Backbone.View.extend(
    tagName:  "div"
    className: "subtitles-scroller"
    pageSize: 3

    initialize: () ->
      this.listenTo(this.model, 'change:i', () =>
        this.onPositionChange()
      )
      this.listenTo(this.model, 'change:processedLines', () =>
        this.render()
      )

      this.on('toggleTranslation', () =>
        scrollerEl = this.$el
        if (scrollerEl.hasClass('show-translation'))
          scrollerEl.removeClass('show-translation')
        else
          scrollerEl.addClass('show-translation')
      )

    render: () ->

      if this.getLength() is 0
        this.$el.html(this.getNoSubtitlesMessage())
      else
        formattedData = this.getFormattedData()
        model =
          data: formattedData
          showTimestamps: this.model.get('showTimestamps')
        this.$el.html(Handlebars.templates['subtitles-scroller'](model))

        view = this
        this.$('.subtitles a').on('click', (event) ->
          query = $(this).attr('data-lookup')
          view.trigger('lookup', query)
        )

        this.onPositionChange()

      return this

    getNoSubtitlesMessage: () ->
      return Handlebars.templates['no-subtitles']()

    getFormattedData: () ->
      data = []
      processedLines = this.model.get('processedLines')
      if not processedLines?.length > 0
        return data

      for line in processedLines
        subtitlesElements = ''
        for word in line.subtitles
          # it is either an object or a string, the object should become a link, otherwise just pass along text
          if word.word?
            subtitlesElements += '<a href="javaScript:void(0);" class="' + word.tag + '" data-lookup="' + word.lookup + '">' + word.word + '</a>&nbsp;'
          else
            subtitlesElements += word
            
        data.push(
          original: subtitlesElements
          translation: line.translation
          ts: line.ts
        )

      return data

    getLength: () ->
      lines = this.model.get('processedLines')
      if lines
        return lines.length
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
      topMargin = -(page * (this.pageSize * this.lineHeight))
      this.$('.subtitles').css('margin-top', topMargin + 'px')

    selectLine: (i) ->
      this.$('.subtitles .subtitle').each((index, el) ->
        if index is i
          $(el).addClass('active')
        else
          $(el).removeClass('active')
      )

  )

  return SubtitlesScrollerView