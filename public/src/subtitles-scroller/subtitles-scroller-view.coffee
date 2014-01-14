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
    className: "subtitlesScroller"
    lineHeight: 96
    pageSize: 4

    initialize: () ->
      this.listenTo(this.model, 'change:i', () =>
        this.onPositionChange()
      )
      this.listenTo(this.model, 'change:subtitles', () =>
        this.render()
      )

    render: () ->
      subtitles = this.model.get('subtitles')

      if this.getLength() is 0
        this.$el.html(this.getNoSubtitlesMessage())
      else
        formattedData = this.getFormattedData(subtitles.original, subtitles.translation)
        model =
          data: formattedData
        this.$el.html(Handlebars.templates['subtitles-scroller'](model))

        view = this
        this.$('.subtitles a').on('click', (event) ->
          query = $(this).html()
          view.trigger('lookup', query)
        )

        this.onPositionChange()

      return this

    getNoSubtitlesMessage: () ->
      return Handlebars.templates['no-subtitles']()

    getFormattedData: (original, translation) ->
      data = []
      if not original?
        return data

      for i in [0..this.getLength()-1]
        if not original[i]
          return data

        translationLine = ''
        if translation? and translation[i]?
          translationLine = translation[i]

        originalText = original[i].text.replace(/(\w+)/g, '<a href="javaScript:void(0);">$1</a>')

        data.push(
          original: originalText
          translation: translationLine
          ts: original[i].ts
        )

      return data

    getLength: () ->
      subtitles = this.model.get('subtitles')
      if subtitles.original
        return subtitles.original.length
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
      page = Math.floor(i/this.pageSize)
      topMargin = -(page * (this.pageSize * this.lineHeight))
      this.$('.subtitles').css('margin-top', topMargin + 'px')

    selectLine: (i) ->
      this.$('.subtitles .subtitle').each((index, el) ->
        if index is i
          $(el).addClass('selected')
        else
          $(el).removeClass('selected')
      )

  )

  return SubtitlesScrollerView