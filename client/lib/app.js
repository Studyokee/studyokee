(function() {
  require(['backbone', 'jquery', 'settings', 'header.view', 'header.model', 'footer.view'], function(Backbone, $, Settings, HeaderView, HeaderModel, FooterView) {
    var AppRouter, appRouter, dataDom, footerView, headerModel, headerView, language, params, settings, user;
    AppRouter = Backbone.Router.extend({
      routes: {
        '': 'home',
        'classrooms/language/:from/:to': 'getClassrooms',
        'songs/:id/edit': 'editSong',
        'classrooms/create': 'createClassroom',
        'classrooms/:id/edit': 'editClassroom',
        'classrooms/:id': 'viewClassroom',
        'vocabulary/:from/:to': 'vocabulary',
        'login': 'login',
        'signup': 'signup',
        '*actions': 'getClassrooms'
      },
      execute: function(callback, args) {
        if (typeof window.subtitlesControlsTeardown === "function") {
          window.subtitlesControlsTeardown();
        }
        if (callback) {
          return callback.apply(this, args);
        }
      }
    });
    if (window.location.hash === '#_=_') {
      window.location.hash = '';
    }
    appRouter = new AppRouter;
    dataDom = $('#data-dom');
    user = {
      id: dataDom.attr('data-user-id'),
      admin: dataDom.attr('data-user-admin'),
      username: dataDom.attr('data-username'),
      displayName: dataDom.attr('data-user-displayName')
    };
    settings = new Settings({
      user: user
    });
    language = dataDom.attr('data-language');
    if (language != null) {
      settings.setFromLangauge(language);
    }
    headerModel = new HeaderModel({
      settings: settings
    });
    headerView = new HeaderView({
      model: headerModel
    });
    footerView = new FooterView({
      model: settings
    });
    appRouter.on('route:home', function() {
      return require(['home.model', 'home.view'], function(HomeModel, HomeView) {
        this.view = new HomeView({
          model: new HomeModel({
            settings: settings
          })
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        return footerView.setElement($('#skee footer')).render();
      });
    });
    appRouter.on('route:viewClassroom', function(id) {
      return require(['classroom.model', 'classroom.view'], function(ClassroomModel, ClassroomView) {
        var classroomModel;
        classroomModel = new ClassroomModel({
          settings: settings,
          id: id
        });
        this.view = new ClassroomView({
          model: classroomModel
        });
        classroomModel.on('change:vocabulary', function() {
          return headerModel.trigger('vocabularyUpdate', classroomModel.get('vocabulary'));
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        return footerView.setElement($('#skee footer')).render();
      });
    });
    appRouter.on('route:vocabulary', function(from, to) {
      return require(['vocabulary.model', 'vocabulary.view'], function(VocabularyModel, VocabularyView) {
        var vocabularyModel;
        if (!user.id) {
          Backbone.history.navigate('login?callbackURL=' + Backbone.history.getFragment(), {
            trigger: true
          });
          return;
        }
        settings.setFromLangauge(from);
        vocabularyModel = new VocabularyModel({
          settings: settings
        });
        vocabularyModel.on('vocabularyUpdate', function(words) {
          return headerModel.trigger('vocabularyUpdate', words);
        });
        this.view = new VocabularyView({
          model: vocabularyModel
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        return footerView.setElement($('#skee footer')).render();
      });
    });
    appRouter.on('route:getClassrooms', function(from, to) {
      return require(['classrooms.model', 'classrooms.view'], function(ClassroomsModel, ClassroomsView) {
        settings.setFromLangauge(from);
        this.view = new ClassroomsView({
          model: new ClassroomsModel({
            settings: settings
          })
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        return footerView.setElement($('#skee footer')).render();
      });
    });
    appRouter.on('route:editSong', function(id) {
      return require(['edit.song.model', 'edit.song.view'], function(EditSongModel, EditSongView) {
        this.view = new EditSongView({
          model: new EditSongModel({
            settings: settings,
            id: id
          })
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        return footerView.setElement($('#skee footer')).render();
      });
    });
    appRouter.on('route:createClassroom', function() {
      return require(['create.classroom.model', 'create.classroom.view'], function(CreateClassroomModel, CreateClassroomView) {
        if (!user.id) {
          Backbone.history.navigate('login', {
            trigger: true
          });
          return;
        }
        this.view = new CreateClassroomView({
          model: new CreateClassroomModel({
            settings: settings
          })
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        return footerView.setElement($('#skee footer')).render();
      });
    });
    appRouter.on('route:editClassroom', function(id) {
      return require(['edit.classroom.model', 'edit.classroom.view'], function(EditClassroomModel, EditClassroomView) {
        console.log('open edit classroom');
        if (!user.id) {
          Backbone.history.navigate('login', {
            trigger: true
          });
          return;
        }
        this.view = new EditClassroomView({
          model: new EditClassroomModel({
            settings: settings,
            id: id
          })
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        return footerView.setElement($('#skee footer')).render();
      });
    });
    appRouter.on('route:login', function() {
      return require(['login.view'], function(LoginView) {
        this.view = new LoginView({
          model: settings
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        return footerView.setElement($('#skee footer')).render();
      });
    });
    appRouter.on('route:signup', function() {
      return require(['signup.view'], function(SignupView) {
        this.view = new SignupView({
          model: settings
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        return footerView.setElement($('#skee footer')).render();
      });
    });
    appRouter.on('route:defaultRoute', function() {
      return require(['home.model', 'home.view'], function(HomeModel, HomeView) {
        console.log('go to default route');
        this.view = new HomeView({
          model: new HomeModel({
            settings: settings
          })
        });
        headerView.setElement($('#skee header')).render();
        this.view.setElement($('#skee .main')).render();
        footerView.setElement($('#skee footer')).render();
        return Backbone.history.navigate('classrooms/' + settings.get('fromLanguage').language + '/' + settings.get('toLanguage').language);
      });
    });
    params = {
      pushState: true,
      root: '/'
    };
    return Backbone.history.start(params);
  });

}).call(this);

/*
//@ sourceMappingURL=app.js.map
*/