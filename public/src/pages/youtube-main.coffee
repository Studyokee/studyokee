require [
  'home.model',
  'home.view',
  'settings',
  'backbone'
], (HomeModel, HomeView, Settings, Backbone) ->

  settings = new Settings()

  homeModel = new HomeModel(
    settings: settings
  )
  homeView = new HomeView(
    model: homeModel
  )
  
  $('.skee').html(homeView.render().el)