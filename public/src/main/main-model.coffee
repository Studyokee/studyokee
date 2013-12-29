define [
  'language.settings.model',
  'subtitles.player.model',
  'suggestions.model',
  'add.song.model',
  'backbone'
], (LanguageSettingsModel, SubtitlesPlayerModel, SuggestionsModel, AddSongModel, Backbone) ->
  MainModel = Backbone.Model.extend(

    initialize: () ->
      settings = this.get('settings')
      musicPlayer = this.get('musicPlayer')
      dataProvider = this.get('dataProvider')
      toLanguage = settings.get('defaultToLanguage')
      fromLanguage = settings.get('defaultFromLanguage')

      languageSettingsModel = new LanguageSettingsModel(
        toLanguage: toLanguage
        fromLanguage: fromLanguage
        enableLogging: settings.get('enableLogging')
      )

      addSongModel = new AddSongModel(
        musicPlayer: musicPlayer
      )

      addSongModel.on('select', (song) =>
        if settings.get('enableLogging')
          console.log('STUDYOKEE APP: select new song from add song: ' + song)
        
        subtitlesPlayerModel.set(
          currentSong: song
        )
      )

      subtitlesPlayerModel = new SubtitlesPlayerModel(
        dataProvider: dataProvider
        musicPlayer: musicPlayer
        toLanguage: toLanguage
        fromLanguage: fromLanguage
        enableLogging: settings.get('enableLogging')
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
        musicPlayer: musicPlayer
        dataProvider: dataProvider
        enableEdit: settings.get('enableEdit')
      )

  )

  return MainModel