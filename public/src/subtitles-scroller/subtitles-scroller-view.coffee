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

    initialize: () ->
      this.listenTo(this.model, 'change:i', () =>
        this.onPositionChange()
      )
      this.listenTo(this.model, 'change:subtitles', () =>
        this.render()
      )

    render: () ->
      subtitles = this.model.get('subtitles')

      if not subtitles.original? or subtitles.original.length == 0
        this.$el.html(this.getNoSubtitlesMessage())
      else
        formattedData = this.getFormattedData(subtitles.original, subtitles.translation)
        model =
          data: formattedData
        this.$el.html(Handlebars.templates['subtitles-scroller'](model))

        this.onPositionChange()

      return this

    getNoSubtitlesMessage: () ->
      return Handlebars.templates['no-subtitles']()

    getFormattedData: (subtitles, translation) ->
      data = []

      for i in [0..subtitles.length-1]
        data.push(
          original: subtitles[i].text
          translation: translation[i]
          ts: subtitles[i].ts
        )

      return data

    onPositionChange: () ->
      i = this.model.get('i')
      this.shiftPage(i)
      this.selectLine(i)

    shiftPage: (i) ->
      pageSize = 4
      lineHeight = 96
      page = Math.floor(i/pageSize)
      topMargin = -(page * (pageSize * lineHeight))
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