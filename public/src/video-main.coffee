require [
  'home.model',
  'home.view',
  'youtube.main.model',
  'youtube.main.view',
  'suggestions.model',
  'suggestions.view',
  'youtube.translation.data.provider',
  'settings',
  'backbone'
], (HomeModel, HomeView, MainModel, MainView, SuggestionsModel, SuggestionsView, DataProvider, Settings, Backbone) ->

  settings = new Settings()

  homeModel = new HomeModel(
    settings: settings
  )
  homeView = new HomeView(
    model: homeModel
  )

  suggestionsModel = new SuggestionsModel(
    settings: settings
    dataProvider: new DataProvider(settings)
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
  suggestionsView.on('select', () =>
    homeView.trigger('toggleMenu')
  )
  mainModel.listenTo(suggestionsModel, 'change:selectedItem', () ->
    mainModel.trigger('changeSong', suggestionsModel.get('selectedItem'))
  )
  
  $('.skee').html(homeView.render().el)