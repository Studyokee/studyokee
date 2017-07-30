(function() {
  define(['backbone', 'handlebars', 'purl', 'templates'], function(Backbone, Handlebars, Purl) {
    var SignupView;
    SignupView = Backbone.View.extend({
      className: "container",
      initialize: function() {},
      render: function() {
        var _this = this;
        this.$el.html(Handlebars.templates['signup'](this.model.toJSON()));
        this.$('#submit').on('click', function(event) {
          var password, username;
          username = _this.$('#username').val();
          password = _this.$('#password').val();
          _this.signup(username, password, $.url(document.location).param().redirectUrl);
          return event.preventDefault();
        });
        return this;
      },
      signup: function(username, password, redirectUrl) {
        var user,
          _this = this;
        user = {
          username: username,
          password: password
        };
        $('.registerWarning .alert').alert('close');
        return $.ajax({
          type: 'POST',
          url: '/signup',
          data: user,
          success: function(response, s, t) {
            if (redirectUrl) {
              return document.location = redirectUrl;
            } else {
              return document.location = '/classrooms/1';
            }
          },
          error: function(err) {
            if (err.responseText.indexOf('User already exists') > 0) {
              return $('.registerWarning').html(_this.getAlert('Username already exists!'));
            } else if (err.responseText.indexOf('User signup limit') > 0) {
              return $('.registerWarning').html(_this.getAlert('User signup limit reached!'));
            }
          }
        });
      },
      getAlert: function(text) {
        return '<div class="alert alert-warning alert-dismissible fade in" role="alert"> <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button> ' + text + '</div>';
      }
    });
    return SignupView;
  });

}).call(this);

/*
//@ sourceMappingURL=signup-view.js.map
*/