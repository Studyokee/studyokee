require [
  'home.model',
  'home.view',
  'youtube.main.model',
  'youtube.main.view',
  'settings',
  'backbone'
], (HomeModel, HomeView, MainModel, MainView, Settings, Backbone) ->

  settings = new Settings()

  homeModel = new HomeModel(
    settings: settings
  )
  homeView = new HomeView(
    model: homeModel
  )

  menuView = new Backbone.View()
  homeView.menuView = menuView
  
  mainModel = new MainModel(
    settings: settings
  )
  mainView = new MainView(
    model: mainModel
  )
  homeView.mainView = mainView

  mainView.on('lookup', (query) ->
    homeView.trigger('lookup', query)
  )
  menuView.on('select', (song) =>
    homeView.trigger('toggleMenu')
  )
  
  $('.skee').html(homeView.render().el)