require [
  'classroom.model',
  'classroom.view',
  'settings',
  'backbone'
], (MainModel, MainView, Settings, Backbone) ->

  dataElement = $('#data-dom')
  id = dataElement.attr('data-id')
  
  settings = new Settings()

  mainModel = new MainModel(
    settings: settings
    id: id
  )
  mainView = new MainView(
    model: mainModel
  )
  
  $('.skee').html(mainView.render().el)