define [
  'language.settings.view',
  'subtitles.player.view',
  'suggestions.view',
  'add.song.view',
  'backbone'
], (LanguageSettingsView, SubtitlesPlayerView, SuggestionsView, AddSongView, Backbone) ->
  MainView = Backbone.View.extend(
    tagName:  "div"
    className: "mainPage"
    
    initialize: () ->
      languageSettingsModel = this.model.get('languageSettingsModel')
      this.languageSettingsView = new LanguageSettingsView(
        model: languageSettingsModel
      )
      this.suggestionsView = new SuggestionsView(
        model: this.model.get('suggestionsModel')
      )
      this.suggestionsView.on('select', () =>
        this.model.get('subtitlesPlayerModel').play()
      )

      this.addSongView = new AddSongView(
        model: this.model.get('addSongModel')
      )
      this.subtitlesPlayerView = new SubtitlesPlayerView(
        model: this.model.get('subtitlesPlayerModel')
      )
      this.subtitlesPlayerView.on('edit', (song) =>
        language = this.model.get('language')
        this.upload(song.id, languageSettingsModel.get('fromLanguage'), languageSettingsModel.get('toLanguage'))
      )

      this.addSongView.on('select', (toAdd) =>
        artist = toAdd.artist
        song = toAdd.name
        id = toAdd.key
        this.upload(id, languageSettingsModel.get('fromLanguage'), languageSettingsModel.get('toLanguage'))
      )

      this.on('disableKeyboard', () =>
        this.model.get('subtitlesPlayerModel').set(
          enableKeyboard: false
        )
      )

      this.on('enableKeyboard', () =>
        this.model.get('subtitlesPlayerModel').set(
          enableKeyboard: true
        )
      )

    render: () ->
      this.$el.html(Handlebars.templates['main'](this.model.toJSON()))

      #this.$('.settingsContainer').html(this.languageSettingsView.render().el)
      this.$('.suggestionsContainer').html(this.suggestionsView.render().el)
      this.$('.searchContainer').html(this.addSongView.render().el)
      this.$('.playerContainer').html(this.subtitlesPlayerView.render().el)
      this.$('.rdioLink').html(Handlebars.templates['rdio-link']())
      this.$('.disclaimersContainer').html(Handlebars.templates['disclaimers']())

      return this

    upload: (id, fromLanguage, toLanguage) ->
      window.location.href = '/upload/' + id + '/' + fromLanguage + '/' + toLanguage

  )

  return MainView