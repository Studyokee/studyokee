(function() {
  define(['backbone', 'handlebars', 'jquery.ui.effect', 'bootstrap', 'templates'], function(Backbone, Handlebars) {
    var HeaderView;
    HeaderView = Backbone.View.extend({
      tagName: "header",
      initialize: function(options) {
        var _this = this;
        this.options = options;
        this.listenTo(this.model, 'change:classrooms', function() {
          return _this.render();
        });
        this.listenTo(this.model, 'change:vocabularyCount', function() {
          var badge, hide, remove, vocabularyCount;
          vocabularyCount = this.model.get('vocabularyCount');
          badge = $('.vocabulary-link .badge');
          if (vocabularyCount > 0) {
            badge.show();
          }
          badge.html(vocabularyCount);
          badge.addClass('throb');
          remove = function() {
            return badge.removeClass('throb');
          };
          setTimeout(remove, 1000);
          if (vocabularyCount === 0) {
            hide = function() {
              return badge.hide();
            };
            return setTimeout(hide, 1000);
          }
        });
        return this.listenTo(this.model, 'change:user', function() {
          return _this.render();
        });
      },
      render: function() {
        var _this = this;
        this.$el.html(Handlebars.templates['header'](this.model.toJSON()));
        this.$('[data-toggle="popover"]').popover();
        $('.userInfoDrawer').on('shown.bs.popover', function() {
          _this.$('.updateUser').click(function() {
            var callback, displayName, password, updates, username;
            _this.$('.updateUser').html('Saving...');
            updates = {};
            displayName = $('#displayName').val();
            username = $('#username').val();
            password = $('#password').val();
            if (displayName) {
              updates.displayName = displayName;
            }
            if (username) {
              updates.username = username;
            }
            if (password) {
              updates.password = password;
            }
            callback = function() {
              return this.$('.updateUser').html('Update');
            };
            return _this.model.updateUser(updates, callback);
          });
          return _this.$('.closeUpdateUser').click(function() {
            return $('.userInfoDrawer').popover('hide');
          });
        });
        if (this.options.sparse) {
          this.$('.navbar-left').hide();
        }
        return this;
      }
    });
    return HeaderView;
  });

}).call(this);

/*
//@ sourceMappingURL=header-view.js.map
*/