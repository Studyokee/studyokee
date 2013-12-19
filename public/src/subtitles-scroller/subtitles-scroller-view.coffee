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
      if not this.options.showTimestamps?
        this.options.showTimestamps = false
        
      this.listenTo(this.model, 'change:i', () =>
        this.onPositionChange()
      )
      this.listenTo(this.model, 'change:subtitles', () =>
        this.render()
      )

    render: () ->
      subtitles = this.model.get('subtitles')
      if not subtitles.original? or subtitles.original.length == 0
        noSubtitles = this.showNoSubtitlesMessage()
        this.$el.html(noSubtitles)
      else
        model =
          data: this.getFormattedData(subtitles.original, subtitles.translation)
          showTimestamps: true
        this.$el.html(Handlebars.templates['subtitles-scroller'](model))

        this.onPositionChange()

      return this

    showNoSubtitlesMessage: () ->
      return Handlebars.templates['no-subtitles']()

    getFormattedData: (subtitles, translation) ->
      data = []

      for i in [0..subtitles.length-1]
        original = ''
        line = subtitles[i].text
        if line?
          original = line.split(' ')

        data.push(
          original: original
          translation: translation[i]
          ts: subtitles[i].ts
        )

      return data

    # Update the lines shown in the window and the highlighted line
    onPositionChange: () ->
      i = this.model.get('i')
      if not i?
        return

      console.log("onPositionChange: i: " + i)
      topMargin = -(i * 65) + 170
      this.$('.subtitles').css('margin-top', topMargin + 'px')
      this.$('.subtitles .subtitle').each((index, el) ->
        if index is i
          $(el).addClass('selected')
        else
          $(el).removeClass('selected')
      )
  )

  return SubtitlesScrollerView