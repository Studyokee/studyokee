define [
  'subtitles.player.view',
  'suggestions.view',
  'dictionary.view',
  'backbone',
  'handlebars',
  'templates'
], (SubtitlesPlayerView, SuggestionsView, DictionaryView, Backbone, Handlebars) ->
  MainView = Backbone.View.extend(
    tagName:  "div"
    className: "rdioMain"
    
    initialize: () ->
      this.suggestionsView = new SuggestionsView(
        model: this.model.suggestionsModel
      )
      this.suggestionsView.on('select', () =>
        this.trigger('toggleMenu')
        this.model.subtitlesPlayerModel.play()
      )

      this.subtitlesPlayerView = new SubtitlesPlayerView(
        model: this.model.subtitlesPlayerModel
      )

      this.listenTo(this.subtitlesPlayerView, 'lookup', (query) =>
        this.model.lookup(query)
        this.$('.dictionaryContainer').addClass('active')

        this.dictionaryView.on('close', () =>
          this.$('.dictionaryContainer').removeClass('active')
        )
      )

      this.dictionaryView = new DictionaryView(
        model: this.model.dictionaryModel
      )

      this.on('toggleMenu', () =>
        this.$('.menu').toggleClass('active')
      )

    render: () ->
      this.$el.html(Handlebars.templates['rdio-main'](this.model.toJSON()))

      this.$('.suggestionsContainer').html(this.suggestionsView.render().el)
      this.$('.playerContainer').html(this.subtitlesPlayerView.render().el)
      this.$('.dictionaryContainer').html(this.dictionaryView.render().el)

      return this

  )

  return MainView