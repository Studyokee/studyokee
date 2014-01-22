define [
  'language.settings.view',
  'subtitles.player.view',
  'suggestions.view',
  'add.song.view',
  'dictionary.view',
  'backbone'
], (LanguageSettingsView, SubtitlesPlayerView, SuggestionsView, AddSongView, DictionaryView, Backbone) ->
  MainView = Backbone.View.extend(
    tagName:  "div"
    className: "mobileMainPage"
    
    initialize: () ->
      this.subtitlesPlayerView = new SubtitlesPlayerView(
        model: this.model.subtitlesPlayerModel
      )

      this.dictionaryView = new DictionaryView(
        model: this.model.dictionaryModel
      )

      this.subtitlesPlayerView.on('lookup', (query) =>
        this.dictionaryView.model.set(
          lookup: query
        )
        this.$('.overlay').show()

        this.$('.overlay .close').on('click', () =>
          this.$('.overlay').hide()
        )
      )

      this.hasInitializedMenu = false

    render: () ->
      this.$el.html(Handlebars.templates['mobile-main'](this.model.toJSON()))

      this.$('.playerContainer').html(this.subtitlesPlayerView.render().el)
      this.$('.overlayBody').html(this.dictionaryView.render().el)
      this.$('.rdioLink').html(Handlebars.templates['rdio-link']())
      this.$('.disclaimersContainer').html(Handlebars.templates['disclaimers']())

      this.$('.openMenu').on('click', () =>
        if this.$('.menu').is(':visible')
          this.hideMenu()
        else
          this.showMenu()
      )

      return this

    showMenu: () ->
      if not this.hasInitializedMenu
        this.suggestionsView = new SuggestionsView(
          model: this.model.suggestionsModel
        )
        this.suggestionsView.on('select', () =>
          this.model.subtitlesPlayerModel.play()
        )

        this.addSongView = new AddSongView(
          model: this.model.addSongModel
        )

        this.addSongView.on('select', (toAdd) =>
          artist = toAdd.artist
          song = toAdd.name
          id = toAdd.key
          this.upload(id, this.model.languageSettingsModel.get('fromLanguage'), this.model.languageSettingsModel.get('toLanguage'))
        )
        this.$('.suggestionsContainer').html(this.suggestionsView.render().el)
        this.$('.searchContainer').html(this.addSongView.render().el)

        this.hasInitializedMenu = true

      this.$('.menu').show()

    hideMenu: () ->
      this.$('.menu').hide()
  )

  return MainView