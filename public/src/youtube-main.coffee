require [
  'home.model',
  'home.view',
  'youtube.main.model',
  'youtube.main.view',
  'suggestions.model',
  'suggestions.view',
  'youtube.suggestions.data.provider',
  'settings',
  'backbone'
], (HomeModel, HomeView, MainModel, MainView, SuggestionsModel, SuggestionsView, SuggestionsDataProvider, Settings, Backbone) ->

  settings = new Settings()

  suggestionsModel = new SuggestionsModel(
    settings: settings
    dataProvider: new SuggestionsDataProvider(settings)
  )
  suggestionsView = new SuggestionsView(
    model: suggestionsModel
  )

  mainModel = new MainModel(
    settings: settings
  )
  mainView = new MainView(
    model: mainModel
  )

  homeModel = new HomeModel(
    settings: settings
  )
  homeView = new HomeView(
    model: homeModel
    mainView: mainView
    menuView: suggestionsView
  )

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