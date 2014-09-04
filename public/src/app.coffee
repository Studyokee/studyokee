require [
  'backbone',
  'jquery',
  'settings',
  'home.model',
  'home.view',
  'header.view',
  'edit.song.model',
  'edit.song.view',
  'create.classroom.model',
  'create.classroom.view',
  'classrooms.model',
  'classrooms.view',
  'edit.classroom.model',
  'edit.classroom.view',
  'classroom.model',
  'classroom.view'
], (Backbone, $, Settings, HomeModel, HomeView, HeaderView, EditSongModel, EditSongView, CreateClassroomModel, CreateClassroomView, ClassroomsModel, ClassroomsView, EditClassroomModel, EditClassroomView, ClassroomModel, ClassroomView) ->

  AppRouter = Backbone.Router.extend(
    routes:
      '': 'home'
      'classrooms/:from/:to': 'getClassrooms'
      'songs/:id/edit': 'editSong'
      'classrooms/create': 'createClassroom'
      'classrooms/:id/edit': 'editClassroom'
      'classrooms/:id': 'viewClassroom'
      'login': 'login'
      '*actions': 'defaultRoute'
  )

  appRouter = new AppRouter

  userId = $('#data-dom').attr('data-user-id')

  settings = new Settings(
    userId: userId
  )

  headerView = new HeaderView(
    model: settings
  )
  $('.headerContainer').html(headerView.render().el)

  toLogin = () ->
    $('.skee').html('<h4>You must login to complete this action.</h4><a href="/auth/facebook">Login with Facebook</a>')
    Backbone.history.navigate('login')


  appRouter.on('route:home', () ->
    view = new HomeView(
      model: new HomeModel(
        settings: settings
      )
    )
    $('.skee').html(view.render().el)
  )
  appRouter.on('route:editSong', (id) ->
    view = new EditSongView(
      model: new EditSongModel(
        settings: settings
        id: id
      )
    )
    $('.skee').html(view.render().el)
  )
  appRouter.on('route:createClassroom', () ->
    if not userId
      toLogin()
      return

    view = new CreateClassroomView(
      model: new CreateClassroomModel(
        settings: settings
      )
    )
    $('.skee').html(view.render().el)
  )
  appRouter.on('route:editClassroom', (id) ->
    if not userId
      toLogin()
      return

    view = new EditClassroomView(
      model: new EditClassroomModel(
        settings: settings
        id: id
      )
    )
    $('.skee').html(view.render().el)
  )
  appRouter.on('route:viewClassroom', (id) ->
    view = new ClassroomView(
      model: new ClassroomModel(
        settings: settings
        id: id
      )
    )
    $('.skee').html(view.render().el)
  )
  appRouter.on('route:login', () ->
    toLogin()
  )
  appRouter.on('route:getClassrooms', (from, to) ->
    settings.setFromLangauge(from)
    console.log('toLanguage: ' + to)
    view = new ClassroomsView(
      model: new ClassroomsModel(
        settings: settings
      )
    )
    $('.skee').html(view.render().el)
  )
  appRouter.on('route:defaultRoute', () ->
    view = new HomeView(
      model: new HomeModel(
        settings: settings
      )
    )
    $('.skee').html(view.render().el)
    Backbone.history.navigate('classrooms/' + settings.get('fromLanguage').language + '/' + settings.get('toLanguage').language)
  )
  params =
    pushState: true
    root: '/'
  Backbone.history.start(params)