require [
  'backbone',
  'jquery',
  'settings',
  'home.model',
  'home.view',
  'header.view',
  'footer.view',
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
], (Backbone, $, Settings, HomeModel, HomeView, HeaderView, FooterView, EditSongModel, EditSongView, CreateClassroomModel, CreateClassroomView, ClassroomsModel, ClassroomsView, EditClassroomModel, EditClassroomView, ClassroomModel, ClassroomView) ->

  AppRouter = Backbone.Router.extend(
    routes:
      '': 'home'
      'classrooms/language/:from/:to': 'getClassrooms'
      'songs/:id/edit': 'editSong'
      'classrooms/create': 'createClassroom'
      'classrooms/:id/edit': 'editClassroom'
      'classrooms/:id': 'viewClassroom'
      'login': 'login'
      '*actions': 'defaultRoute'
    execute: (callback, args) ->
      if this.view then this.view.remove()
      if callback then callback.apply(this, args)
  )

  appRouter = new AppRouter

  dataDom = $('#data-dom')
  user =
    id: dataDom.attr('data-user-id')
    displayName: dataDom.attr('data-user-display-name')
    photo: dataDom.attr('data-user-photo')
    firstName: dataDom.attr('data-user-first-name')

  settings = new Settings(
    user: user
  )

  homeHeaderView = new HeaderView(
    model: settings
    sparse: true
  )
  headerView = new HeaderView(
    model: settings
  )
  footerView = new FooterView(
    model: settings
  )

  toLogin = () ->
    $('.skee').html('<h4>You must login to complete this action.</h4><a href="/auth/facebook">Login with Facebook</a>')
    Backbone.history.navigate('login')


  appRouter.on('route:home', () ->
    this.view = new HomeView(
      model: new HomeModel(
        settings: settings
      )
    )
    $('.skee').html(homeHeaderView.render().el)
    $('.skee').append(this.view.render().el)
  )
  appRouter.on('route:editSong', (id) ->
    this.view = new EditSongView(
      model: new EditSongModel(
        settings: settings
        id: id
      )
    )
    $('.skee').html(headerView.render().el)
    $('.skee').append(this.view.render().el)
    $('.skee').append(footerView.render().el)
  )
  appRouter.on('route:createClassroom', () ->
    if not user.id
      toLogin()
      return

    this.view = new CreateClassroomView(
      model: new CreateClassroomModel(
        settings: settings
      )
    )
    $('.skee').html(headerView.render().el)
    $('.skee').append(this.view.render().el)
    $('.skee').append(footerView.render().el)
  )
  appRouter.on('route:editClassroom', (id) ->
    console.log('open edit classroom')
    if not user.id
      toLogin()
      return

    this.view = new EditClassroomView(
      model: new EditClassroomModel(
        settings: settings
        id: id
      )
    )
    $('.skee').html(headerView.render().el)
    $('.skee').append(this.view.render().el)
    $('.skee').append(footerView.render().el)
  )
  appRouter.on('route:viewClassroom', (id) ->
    this.view = new ClassroomView(
      model: new ClassroomModel(
        settings: settings
        id: id
      )
    )
    $('.skee').html(headerView.render().el)
    $('.skee').append(this.view.render().el)
    $('.skee').append(footerView.render().el)
  )
  appRouter.on('route:login', () ->
    toLogin()
  )
  appRouter.on('route:getClassrooms', (from, to) ->
    settings.setFromLangauge(from)
    this.view = new ClassroomsView(
      model: new ClassroomsModel(
        settings: settings
      )
    )
    $('.skee').html(headerView.render().el)
    $('.skee').append(this.view.render().el)
    $('.skee').append(footerView.render().el)
  )
  appRouter.on('route:defaultRoute', () ->
    console.log('go to default route')
    this.view = new HomeView(
      model: new HomeModel(
        settings: settings
      )
    )
    $('.skee').html(headerView.render().el)
    $('.skee').append(this.view.render().el)
    $('.skee').append(footerView.render().el)
    Backbone.history.navigate('classrooms/' + settings.get('fromLanguage').language + '/' + settings.get('toLanguage').language)
  )
  params =
    pushState: true
    root: '/'
  Backbone.history.start(params)