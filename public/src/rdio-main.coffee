require [
  'home.model',
  'home.view',
  'rdio.main.model',
  'rdio.main.view',
  'suggestions.model',
  'suggestions.view',
  'rdio.suggestions.data.provider'
  'settings',
  'backbone'
], (HomeModel, HomeView, MainModel, MainView, SuggestionsModel, SuggestionsView, SuggestionsDataProvider, Settings, Backbone) ->

  settings = new Settings()

  homeModel = new HomeModel(
    settings: settings
  )
  homeView = new HomeView(
    model: homeModel
  )

  suggestionsModel = new SuggestionsModel(
    settings: settings
    dataProvider: new SuggestionsDataProvider(settings)
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
  mainModel.listenTo(suggestionsModel, 'change:selectedItem', () ->
    mainModel.trigger('changeSong', suggestionsModel.get('selectedItem'))
  )
  
  $('.skee').html(homeView.render().el)