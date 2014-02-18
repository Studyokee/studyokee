require [
  'classrooms.model',
  'classrooms.view',
  'settings',
  'backbone'
], (MainModel, MainView, Settings, Backbone) ->

  settings = new Settings()

  mainModel = new MainModel(
    settings: settings
  )
  mainView = new MainView(
    model: mainModel
  )
  
  $('.skee').html(mainView.render().el)