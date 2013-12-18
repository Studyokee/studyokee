require [
  'settings',
  'music.player',
  'studyokee.translation.data.provider',
  'main.model',
  'main.view'
], (Settings, MusicPlayer, StudyokeeTranslationDataProvider, MainModel, MainView) ->

  settings = new Settings()
  musicPlayer = new MusicPlayer()
  dataProvider = new StudyokeeTranslationDataProvider()

  model = new MainModel(
    settings: settings
    musicPlayer: musicPlayer
    dataProvider: dataProvider
  )
  view = new MainView(
    model: model
  )
  $('.skee').html(view.render().el)