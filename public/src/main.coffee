require [
  'settings',
  'music.player',
  'studyokee.translation.data.provider',
  'main.model',
  'main.view'
], (Settings, MusicPlayer, StudyokeeTranslationDataProvider, MainModel, MainView) ->

  settings = new Settings()
  if settings.get('enableLogging')
    settings.set(
      loadStartTime: window.loadStartTime
    )
    startTime = new Date().getTime()
    console.log('File load time: ' + (startTime - window.loadStartTime))
    console.log('Render page start: ' + startTime)
  musicPlayer = new MusicPlayer(
    settings: settings
  )
  dataProvider = new StudyokeeTranslationDataProvider(settings)

  model = new MainModel(
    settings: settings
    musicPlayer: musicPlayer
    dataProvider: dataProvider
  )
  view = new MainView(
    model: model
  )
  $('.skee').html(view.render().el)

  if settings.get('enableLogging')
    endTime = new Date().getTime()
    console.log('Render page end: ' + endTime + ', total time: ' + (endTime - settings.get('loadStartTime')))