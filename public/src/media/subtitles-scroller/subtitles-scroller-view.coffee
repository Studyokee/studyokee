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
    className: "subtitles-scroller panel panel-default"
    pageSize: 3

    initialize: () ->
      this.listenTo(this.model, 'change:i', () =>
        this.onPositionChange()
      )
      this.listenTo(this.model, 'change:subtitles', () =>
        this.render()
      )
      this.on('sizeChange', () =>
        this.onPositionChange()
      )
      this.model.on('highlightUpdate', () =>
        this.render()
      )

    render: () ->
      subtitles = this.model.get('subtitles')
      translation = this.model.get('translation')

      if this.getLength() is 0
        this.$el.html(this.getNoSubtitlesMessage())
      else
        formattedData = this.getFormattedData(subtitles, translation)
        model =
          data: formattedData
          showTimestamps: this.model.get('showTimestamps')
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

        originalText = ''
        # get all words
        regex = /([ÀÈÌÒÙàèìòùÁÉÍÓÚÝáéíóúýÂÊÎÔÛâêîôûÃÑÕãñõÄËÏÖÜŸäëïöüŸçÇŒœßØøÅåÆæÞþÐð\w]+)/gi
        words = original[i].text.match(regex)
        if not words?
          words = []
          originalText = original[i].text
        else
          for word in words
            tag = this.getTag(word)
            originalText += '<a href="javaScript:void(0);" class="' + tag + '">' + word + '</a>&nbsp;'

        data.push(
          original: originalText
          translation: translationLine
          ts: original[i].ts
        )

      return data

    getTag: (word) ->
      known = this.model.get('known')
      unknown = this.model.get('unknown')
      # add links
      # highlight known vocabulary words with blue
      # highlight unknown vocabulary words with green
      lower = word.toLowerCase()
      if known[lower]?
        return'known'
      else if unknown[lower]?
        return 'unknown'

      #stemming
      ###if lower.length > 2
        if known[lower.substr(0, word.length-1) + 'a']? or known[lower.substr(0, word.length-1) + 'o']?
          return'known'
        else if unknown[word.substr(0, lower.length-1) + 'a']? or unknown[lower.substr(0, word.length-1) + 'o']?
          return 'unknown'###

      return ''

    getLength: () ->
      subtitles = this.model.get('subtitles')
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