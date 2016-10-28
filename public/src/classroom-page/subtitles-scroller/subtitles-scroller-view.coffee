define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  SubtitlesScrollerView = Backbone.View.extend(
    className: "subtitles-scroller show-translation"
    pageSize: 3

    initialize: () ->
      this.listenTo(this.model, 'change:i', () =>
        i = this.model.get('i')
        if i >= this.model.getLength() or i < 0
          return

        this.adjustView()
      )
      this.listenTo(this.model, 'change:formattedData', () =>
        this.render()
      )

      this.on('toggleTranslation', () =>
        this.$el.toggleClass('show-translation')
        this.adjustView()
      )

    render: () ->
      length = this.model.getLength()

      if length is null
        # Waiting for response from server
        this.$el.html(this.getLoadingMessage())
      else if length is []
        # Response came back empty
        this.$el.html(this.getNoSubtitlesMessage())
      else
        this.$el.html(Handlebars.templates['subtitles-scroller'](
          data: this.model.get('formattedData')
        ))

        lookup = (event) =>
          query = $(event.target).attr('data-lookup')
          this.trigger('lookup', query)
          $(event.target).focus
          event.preventDefault()
        this.$('.subtitles a').click(lookup)

        this.adjustView()

        that = this
        $('.subtitle').click(() ->
          that.trigger('selectLine', $(this).index())
        )

      return this

    getLoadingMessage: () ->
      return '<span class="glyphicon glyphicon-refresh glyphicon-spin large-spinner"></span>'

    getNoSubtitlesMessage: () ->
      return '<div class="no-subtitles">Sorry, there are no subtitles for this song</div>'

    # Adjust the page and select the correct line, making sure that i never goes out of bounds
    adjustView: () ->
      i = this.model.get('i')
      this.shiftPage(i)
      this.selectLine(i)

    # Adjust the view port on the scroller parent to show the correct lines
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