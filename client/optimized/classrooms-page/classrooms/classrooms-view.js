(function() {
  define(['backbone', 'classroom.preview.model', 'classroom.preview.view', 'pagination.view', 'handlebars', 'templates'], function(Backbone, ClassroomPreviewModel, ClassroomPreviewView, PaginationView, Handlebars) {
    var ClassroomsView;
    ClassroomsView = Backbone.View.extend({
      initialize: function() {
        var _this = this;
        this.listenTo(this.model, 'change', function() {
          return _this.render();
        });
        this.paginationViewBottom = new PaginationView({
          model: this.model.paginationModel
        });
        return this.paginationViewBottom.on('openPage', function(pageToGet) {
          return _this.model.getClassrooms(pageToGet);
        });
      },
      render: function() {
        var classroom, classroomPreviewView, classrooms, songs, _i, _len;
        this.$el.html(Handlebars.templates['classrooms'](this.model.toJSON()));
        this.$('.paginationContainerBottom').html(this.paginationViewBottom.render().el);
        if (this.model.get('data') != null) {
          classrooms = this.model.get('data');
          for (_i = 0, _len = classrooms.length; _i < _len; _i++) {
            classroom = classrooms[_i];
            songs = null;
            classroomPreviewView = new ClassroomPreviewView({
              model: new ClassroomPreviewModel({
                classroom: classroom
              })
            });
            this.$('.classroomPreviewViews').append(classroomPreviewView.render().el);
          }
        }
        return this;
      }
    });
    return ClassroomsView;
  });

}).call(this);

/*
//@ sourceMappingURL=classrooms-view.js.map
*/