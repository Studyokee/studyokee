require [
  'backbone',
  'jquery',
  'settings',
  'home.model',
  'home.view',
  'login.view',
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
], (Backbone, $, Settings, HomeModel, HomeView, LoginView, HeaderView, FooterView, EditSongModel, EditSongView, CreateClassroomModel, CreateClassroomView, ClassroomsModel, ClassroomsView, EditClassroomModel, EditClassroomView, ClassroomModel, ClassroomView) ->

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
      #if this.view then this.view.remove()
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

  appRouter.on('route:home', () ->
    this.view = new HomeView(
      model: new HomeModel(
        settings: settings
      )
    )
    homeHeaderView.setElement($('#skee header')).render()
    this.view.setElement($('#skee .main')).render()
    footerView.setElement($('#skee footer')).render()
  )
  appRouter.on('route:editSong', (id) ->
    this.view = new EditSongView(
      model: new EditSongModel(
        settings: settings
        id: id
      )
    )
    headerView.setElement($('#skee header')).render()
    this.view.setElement($('#skee .main')).render()
    footerView.setElement($('#skee footer')).render()
  )
  appRouter.on('route:createClassroom', () ->
    if not user.id
      Backbone.history.navigate('login', {trigger: true})
      return

    this.view = new CreateClassroomView(
      model: new CreateClassroomModel(
        settings: settings
      )
    )
    headerView.setElement($('#skee header')).render()
    this.view.setElement($('#skee .main')).render()
    footerView.setElement($('#skee footer')).render()
  )
  appRouter.on('route:editClassroom', (id) ->
    console.log('open edit classroom')
    if not user.id
      Backbone.history.navigate('login', {trigger: true})
      return

    this.view = new EditClassroomView(
      model: new EditClassroomModel(
        settings: settings
        id: id
      )
    )
    headerView.setElement($('#skee header')).render()
    this.view.setElement($('#skee .main')).render()
    footerView.setElement($('#skee footer')).render()
  )
  appRouter.on('route:viewClassroom', (id) ->
    this.view = new ClassroomView(
      model: new ClassroomModel(
        settings: settings
        id: id
      )
    )
    headerView.setElement($('#skee header')).render()
    this.view.setElement($('#skee .main')).render()
    footerView.setElement($('#skee footer')).render()
  )
  appRouter.on('route:login', () ->
    this.view = new LoginView(
      model: settings
    )
    homeHeaderView.setElement($('#skee header')).render()
    this.view.setElement($('#skee .main')).render()
    footerView.setElement($('#skee footer')).render()
  )
  appRouter.on('route:getClassrooms', (from, to) ->
    settings.setFromLangauge(from)
    this.view = new ClassroomsView(
      model: new ClassroomsModel(
        settings: settings
      )
    )
    headerView.setElement($('#skee header')).render()
    this.view.setElement($('#skee .main')).render()
    footerView.setElement($('#skee footer')).render()
  )
  appRouter.on('route:defaultRoute', () ->
    console.log('go to default route')
    this.view = new HomeView(
      model: new HomeModel(
        settings: settings
      )
    )
    headerView.setElement($('#skee header')).render()
    this.view.setElement($('#skee .main')).render()
    footerView.setElement($('#skee footer')).render()
    Backbone.history.navigate('classrooms/' + settings.get('fromLanguage').language + '/' + settings.get('toLanguage').language)
  )
  params =
    pushState: true
    root: '/'
  Backbone.history.start(params)