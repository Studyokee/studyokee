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
    className: "mainPage"
    
    initialize: () ->
      this.languageSettingsView = new LanguageSettingsView(
        model: this.model.languageSettingsModel
      )
      this.suggestionsView = new SuggestionsView(
        model: this.model.suggestionsModel
      )
      this.suggestionsView.on('select', () =>
        this.model.subtitlesPlayerModel.play()
      )

      this.addSongView = new AddSongView(
        model: this.model.addSongModel
      )
      this.subtitlesPlayerView = new SubtitlesPlayerView(
        model: this.model.subtitlesPlayerModel
      )
      this.subtitlesPlayerView.on('edit', (song) =>
        language = this.model.get('language')
        this.upload(song.id, this.model.languageSettingsModel.get('fromLanguage'), this.model.languageSettingsModel.get('toLanguage'))
      )

      this.addSongView.on('select', (toAdd) =>
        artist = toAdd.artist
        song = toAdd.name
        id = toAdd.key
        this.upload(id, this.model.languageSettingsModel.get('fromLanguage'), this.model.languageSettingsModel.get('toLanguage'))
      )

      this.on('disableKeyboard', () =>
        this.model.subtitlesPlayerModel.set(
          enableKeyboard: false
        )
      )

      this.on('enableKeyboard', () =>
        this.model.subtitlesPlayerModel.set(
          enableKeyboard: true
        )
      )

      this.dictionaryView = new DictionaryView(
        model: this.model.dictionaryModel
      )
      this.subtitlesPlayerView.on('lookup', (query) =>
        this.dictionaryView.model.set(
          lookup: query
        )
      )

    render: () ->
      this.$el.html(Handlebars.templates['main'](this.model.toJSON()))

      this.$('.suggestionsContainer').html(this.suggestionsView.render().el)
      this.$('.searchContainer').html(this.addSongView.render().el)
      this.$('.playerContainer').html(this.subtitlesPlayerView.render().el)
      this.$('.dictionaryContainer').html(this.dictionaryView.render().el)
      this.$('.rdioLink').html(Handlebars.templates['rdio-link']())
      this.$('.disclaimersContainer').html(Handlebars.templates['disclaimers']())

      return this

  )

  return MainView