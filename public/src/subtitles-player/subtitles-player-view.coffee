define [
  'backbone',
  'subtitles.scroller.view',
  'subtitles.controls.view',
  'handlebars',
  'templates'
], (Backbone, SubtitlesScrollerView, SubtitlesControlsView, Handlebars) ->

  ####################################################################
  #
  # SubtitlesPlayerView
  #
  # The view for the collection of original subtitles, translated
  # subtitles, controls, and dictionary lookup
  #
  ####################################################################
  SubtitlesPlayerView = Backbone.View.extend(
    tagName:  "div"
    className: "player"
    
    initialize: () ->

      this.subtitlesView = new SubtitlesScrollerView(
        model: this.model
      )

      this.subtitlesControlsView = new SubtitlesControlsView(
        model: this.model
      )

      this.listenTo(this.model, 'change:isLoading', () =>
        if this.model.get('isLoading')
          this.$('.spinnerContainer').show()
        else
          this.$('.spinnerContainer').hide()
      )

      this.listenTo(this.model, 'change:enableKeyboard', () =>
        enableKeyboard = this.model.get('enableKeyboard')
        console.log('enable keyboard player: ' + enableKeyboard)

        if enableKeyboard
          this.enableKeyboard()
        else
          this.disableKeyboard()
      )

      this.enableKeyboard()

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-player'](this.model.toJSON()))
      this.$('.subtitlesContainer').append(Handlebars.templates['spinner']())
      this.$('.subtitlesContainer').append(this.subtitlesView.render().el)
      this.$('.controlsContainer').append(this.subtitlesControlsView.render().el)

      this.$('.edit').on('click', () =>
        currentSong = this.model.get('currentSong')
        this.trigger('edit', currentSong)
      )

      return this

    enableKeyboard: () ->
      console.log('enableKeyboard player')
      $(window).on('keydown', this.onKeyDown)

    disableKeyboard: () ->
      console.log('disableKeyboard player')
      $(window).unbind('keydown', this.onKeyDown)

    onKeyDown: (event) =>
      switch event.keyCode
        when 27
          # esc
          this.$('.dictionaryContainer').hide()

    lookup: (word) ->
      musicPlayer = this.model.get('musicPlayer')
      musicPlayer.pause()

      spinner = Handlebars.templates['spinner']()
      this.$('.dictionaryResults').html(spinner)
      this.$('.dictionaryContainer').show()
      
      this.$('.close').on('click', () =>
        this.$('.dictionaryContainer').hide()
      )

      dictionary = this.model.get('dictionary')
      fromLanguage = this.model.get('fromLanguage')
      toLanguage = this.model.get('toLanguage')
      dictionary.lookup(word, fromLanguage, toLanguage, (result) ->
        this.$('.dictionaryResults').html(result)
      )

  )

  return SubtitlesPlayerView