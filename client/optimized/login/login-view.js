(function() {
  define(['backbone', 'handlebars', 'purl', 'templates'], function(Backbone, Handlebars, Purl) {
    var LoginView;
    LoginView = Backbone.View.extend({
      className: "container",
      initialize: function() {},
      render: function() {
        var params,
          _this = this;
        this.$el.html(Handlebars.templates['login'](this.model.toJSON()));
        params = $.url(document.location).param();
        this.$('#login').on('submit', function(event) {
          var password, username;
          username = _this.$('#username').val();
          password = _this.$('#password').val();
          _this.login(username, password);
          return event.preventDefault();
        });
        return this;
      },
      login: function(username, password) {
        var user,
          _this = this;
        user = {
          username: username,
          password: password
        };
        return $.ajax({
          type: 'POST',
          url: '/login',
          data: user,
          success: function(response) {
            var params, redirectUrl;
            console.log('Success!');
            params = $.url(document.location).param();
            redirectUrl = '/classrooms/language/es/en';
            if (params.redirectUrl != null) {
              redirectUrl = params.redirectUrl + document.location.hash;
            }
            _this.setCookie('username', username);
            _this.setCookie('password', password);
            return document.location = redirectUrl;
          },
          error: function(err) {
            console.log('Error: ' + err.responseText);
            return _this.$('.login-mask').hide();
          }
        });
      },
      readCookie: function(name) {
        var c, ca, nameEQ, _i, _len;
        nameEQ = name + '=';
        ca = document.cookie.split(';');
        for (_i = 0, _len = ca.length; _i < _len; _i++) {
          c = ca[_i];
          while (c.charAt(0) === ' ') {
            c = c.substring(1, c.length);
          }
          if (c.indexOf(nameEQ) === 0) {
            return c.substring(nameEQ.length, c.length);
          }
        }
        return null;
      },
      setCookie: function(name, value) {
        return document.cookie = name + '=' + value + '; Path=/;';
      },
      deleteCookie: function(name) {
        return document.cookie = name(+'=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;');
      }
    });
    return LoginView;
  });

}).call(this);

/*
//@ sourceMappingURL=login-view.js.map
*/