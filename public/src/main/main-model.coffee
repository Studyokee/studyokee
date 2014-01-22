define [
  'language.settings.model',
  'music.player',
  'subtitles.player.model',
  'suggestions.model',
  'add.song.model',
  'dictionary.model',
  'backbone'
], (LanguageSettingsModel, MusicPlayer, SubtitlesPlayerModel, SuggestionsModel, AddSongModel, DictionaryModel, Backbone) ->
  MainModel = Backbone.Model.extend(

    initialize: () ->
      settings = this.get('settings')
      toLanguage = settings.get('defaultToLanguage')
      fromLanguage = settings.get('defaultFromLanguage')

      this.dataProvider = this.get('dataProvider')

      this.dictionaryModel = new DictionaryModel(
        fromLanguage: fromLanguage
        toLanguage: toLanguage
      )

      this.languageSettingsModel = new LanguageSettingsModel(
        toLanguage: toLanguage
        fromLanguage: fromLanguage
        enableLogging: settings.get('enableLogging')
      )

      this.addSongModel = new AddSongModel()

      this.addSongModel.on('select', (song) =>
        if settings.get('enableLogging')
          console.log('STUDYOKEE APP: select new song from add song: ' + song)
        
        this.subtitlesPlayerModel.set(
          currentSong: song
        )
        this.subtitlesPlayerModel.play()
      )

      this.subtitlesPlayerModel = new SubtitlesPlayerModel(
        dataProvider: this.dataProvider
        musicPlayer: new MusicPlayer(
          settings: settings
        )
        toLanguage: toLanguage
        fromLanguage: fromLanguage
        settings: settings
      )

      this.suggestionsModel = new SuggestionsModel(
        dataProvider: this.dataProvider
        toLanguage: toLanguage
        fromLanguage: fromLanguage
        enableLogging: settings.get('enableLogging')
      )

      this.listenTo(this.suggestionsModel, 'change:selectedSong', () =>
        selectedSong = this.suggestionsModel.get('selectedSong')
        if settings.get('enableLogging')
          console.log('STUDYOKEE APP: change selectedSong: ' + selectedSong)
        
        this.subtitlesPlayerModel.set(
          currentSong: selectedSong
        )
      )

      this.listenTo(this.languageSettingsModel, 'change:toLanguage', () =>
        toLanguage = this.languageSettingsModel.get('toLanguage')
        if settings.get('enableLogging')
          console.log('STUDYOKEE APP: change toLanguage: ' + toLanguage)
        
        this.subtitlesPlayerModel.set(
          toLanguage: toLanguage
        )
        this.suggestionsModel.set(
          toLanguage: toLanguage
        )
      )
      this.listenTo(this.languageSettingsModel, 'change:fromLanguage', () =>
        fromLanguage = this.languageSettingsModel.get('fromLanguage')
        if settings.get('enableLogging')
          console.log('STUDYOKEE APP: change fromLanguage: ' + fromLanguage)
        
        this.subtitlesPlayerModel.set(
          fromLanguage: fromLanguage
        )
        this.suggestionsModel.set(
          fromLanguage: fromLanguage
        )
      )

  )

  return MainModel