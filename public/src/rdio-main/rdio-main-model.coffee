define [
  'studyokee.translation.data.provider',
  'rdio.music.player',
  'settings',
  'subtitles.player.model',
  'suggestions.model',
  'dictionary.model',
  'backbone'
], (DataProvider, MusicPlayer, Settings, SubtitlesPlayerModel, SuggestionsModel, DictionaryModel, Backbone) ->
  MainModel = Backbone.Model.extend(

    initialize: () ->
      settings = new Settings()

      dataProvider = new DataProvider(settings)
      musicPlayer = new MusicPlayer(
        settings: settings
      )

      this.suggestionsModel = new SuggestionsModel(
        dataProvider: dataProvider
        settings: settings
      )

      this.subtitlesPlayerModel = new SubtitlesPlayerModel(
        dataProvider: dataProvider
        musicPlayer: musicPlayer
        settings: settings
      )

      this.listenTo(this.suggestionsModel, 'change:selectedSong', () =>
        this.subtitlesPlayerModel.set(
          currentSong: this.suggestionsModel.get('selectedSong')
        )
      )

      this.dictionaryModel = new DictionaryModel(
        fromLanguage: settings.get('fromLanguage')
        toLanguage: settings.get('toLanguage')
      )

    lookup: (query) ->
      this.dictionaryModel.set(
        query: query
      )
  )

  return MainModel