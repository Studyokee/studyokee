require [
  'home.model',
  'home.view',
  'rdio.main.model',
  'rdio.main.view',
  'suggestions.model',
  'suggestions.view',
  'settings',
  'backbone'
], (HomeModel, HomeView, MainModel, MainView, SuggestionsModel, SuggestionsView, Settings, Backbone) ->

  settings = new Settings()

  homeModel = new HomeModel(
    settings: settings
  )
  homeView = new HomeView(
    model: homeModel
  )

  suggestionsModel = new SuggestionsModel(
    settings: settings
  )
  suggestionsView = new SuggestionsView(
    model: suggestionsModel
  )
  homeView.menuView = suggestionsView

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
  suggestionsView.on('select', (song) =>
    homeView.trigger('toggleMenu')
  )
  mainModel.listenTo(suggestionsModel, 'change:selectedSong', () ->
    mainModel.trigger('changeSong', suggestionsModel.get('selectedSong'))
  )
  
  $('.skee').html(homeView.render().el)