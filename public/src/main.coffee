require [
  'home.view',
  'rdio.main.view',
  'rdio.main.model'
], (HomeView, MainView, MainModel) ->

  view = new HomeView()
  view.mainView = new MainView(
    model: new MainModel()
  )
  
  $('.skee').html(view.render().el)