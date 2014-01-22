require [
  'settings',
  'studyokee.translation.data.provider',
  'main.model',
  'mobile.main.view'
], (Settings, StudyokeeTranslationDataProvider, MainModel, MainView) ->

  settings = new Settings()
  dataProvider = new StudyokeeTranslationDataProvider(settings)

  model = new MainModel(
    settings: settings
    dataProvider: dataProvider
  )
  view = new MainView(
    model: model
  )
  $('.skee').html(view.render().el)