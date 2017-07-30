(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var CreateClassroomView;
    CreateClassroomView = Backbone.View.extend({
      initialize: function() {
        var _this = this;
        return this.listenTo(this.model, 'change', function() {
          return _this.render();
        });
      },
      render: function() {
        var view,
          _this = this;
        this.$el.html(Handlebars.templates['create-classroom'](this.model.get('settings').toJSON()));
        view = this;
        this.$('.cancel').on('click', function(event) {
          Backbone.history.navigate('/', {
            trigger: true
          });
          return event.preventDefault();
        });
        this.$('.save').on('click', function(event) {
          var language, name, success;
          name = _this.$('#name').val();
          language = _this.model.get('settings').get('fromLanguage').language;
          success = function(classroom) {
            return Backbone.history.navigate('/classrooms/' + classroom.classroomId + '/edit', {
              trigger: true
            });
          };
          _this.model.saveClassroom(name, language, success);
          return event.preventDefault();
        });
        return this;
      }
    });
    return CreateClassroomView;
  });

}).call(this);

/*
//@ sourceMappingURL=create-classroom-view.js.map
*/