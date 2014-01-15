define [
  'language.settings.model',
  'music.player',
  'subtitles.player.model',
  'suggestions.model',
  'add.song.model',
  'backbone'
], (LanguageSettingsModel, MusicPlayer, SubtitlesPlayerModel, SuggestionsModel, AddSongModel, Backbone) ->
  MainModel = Backbone.Model.extend(

    initialize: () ->
      settings = this.get('settings')
      dataProvider = this.get('dataProvider')
      toLanguage = settings.get('defaultToLanguage')
      fromLanguage = settings.get('defaultFromLanguage')

      languageSettingsModel = new LanguageSettingsModel(
        toLanguage: toLanguage
        fromLanguage: fromLanguage
        enableLogging: settings.get('enableLogging')
      )

      addSongModel = new AddSongModel()

      addSongModel.on('select', (song) =>
        if settings.get('enableLogging')
          console.log('STUDYOKEE APP: select new song from add song: ' + song)
        
        subtitlesPlayerModel.set(
          currentSong: song
        )
        subtitlesPlayerModel.play()
      )

      subtitlesPlayerModel = new SubtitlesPlayerModel(
        dataProvider: dataProvider
        musicPlayer: new MusicPlayer(
          settings: settings
        )
        toLanguage: toLanguage
        fromLanguage: fromLanguage
        settings: settings
      )

      suggestionsModel = new SuggestionsModel(
        dataProvider: dataProvider
        toLanguage: toLanguage
        fromLanguage: fromLanguage
        enableLogging: settings.get('enableLogging')
      )

      this.listenTo(suggestionsModel, 'change:selectedSong', () =>
        selectedSong = suggestionsModel.get('selectedSong')
        if settings.get('enableLogging')
          console.log('STUDYOKEE APP: change selectedSong: ' + selectedSong)
        
        subtitlesPlayerModel.set(
          currentSong: selectedSong
        )
      )

      this.listenTo(languageSettingsModel, 'change:toLanguage', () =>
        toLanguage = languageSettingsModel.get('toLanguage')
        if settings.get('enableLogging')
          console.log('STUDYOKEE APP: change toLanguage: ' + toLanguage)
        
        subtitlesPlayerModel.set(
          toLanguage: toLanguage
        )
        suggestionsModel.set(
          toLanguage: toLanguage
        )
      )
      this.listenTo(languageSettingsModel, 'change:fromLanguage', () =>
        fromLanguage = languageSettingsModel.get('fromLanguage')
        if settings.get('enableLogging')
          console.log('STUDYOKEE APP: change fromLanguage: ' + fromLanguage)
        
        subtitlesPlayerModel.set(
          fromLanguage: fromLanguage
        )
        suggestionsModel.set(
          fromLanguage: fromLanguage
        )
      )

      this.set(
        languageSettingsModel: languageSettingsModel
        addSongModel: addSongModel
        subtitlesPlayerModel: subtitlesPlayerModel
        suggestionsModel: suggestionsModel
        dataProvider: dataProvider
        enableEdit: settings.get('enableEdit')
      )

  )

  return MainModel