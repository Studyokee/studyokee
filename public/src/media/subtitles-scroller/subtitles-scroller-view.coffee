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
          query = $(this).attr('data-lookup')
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
            # if we have a resolution for this word, use that instead of word
            resolutions = this.model.get('resolutions')
            lower = word.toLowerCase()

            if resolutions[lower]
              lower = resolutions[lower].toLowerCase()
              console.log('using: ' + lower + ' instead of ' + word)

            tag = this.getTag(lower)
            originalText += '<a href="javaScript:void(0);" class="' + tag + '" data-lookup="' + lower + '">' + word + '</a>&nbsp;'

        data.push(
          original: originalText
          translation: translationLine
          ts: original[i].ts
        )

      return data

    getTag: (word) ->
      known = this.model.get('known')
      unknown = this.model.get('unknown')
      knownStems = this.model.get('knownStems')
      unknownStems = this.model.get('unknownStems')

      if known[word]?
        return 'known'
      else if unknown[word]?
        return 'unknown'

      #stemming
      endings = ['a','o','as','os','es']
      stem = null
      if word.length > 2
        for suffix in endings
          start = word.indexOf(suffix, word.length - suffix.length)
          if start isnt -1
            # has stem ending, strip down to stem and use that
            stem = word.substr(0, start)
            break

        if stem? and knownStems[stem]?
          return 'known'
        else if stem? and unknownStems[stem]?
          return 'unknown'

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