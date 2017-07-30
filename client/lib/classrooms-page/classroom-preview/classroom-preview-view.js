(function() {
  define(['backbone', 'media.item.list.view', 'handlebars', 'templates'], function(Backbone, MediaItemList, Handlebars) {
    var ClassroomPreviewView;
    ClassroomPreviewView = Backbone.View.extend({
      className: 'classroom-preview col-md-4 col-sm-6',
      tagName: 'div',
      initialize: function() {
        var _this = this;
        this.listenTo(this.model.songListModel, 'change', function() {
          return _this.render();
        });
        return this.songListView = new MediaItemList({
          model: this.model.songListModel,
          readonly: true,
          limit: 3
        });
      },
      render: function() {
        var model,
          _this = this;
        model = this.model.toJSON();
        this.$el.html(Handlebars.templates['classroom-preview'](model));
        this.$('.songListContainer').html(this.songListView.render().el);
        this.$('.classroomLink').on('click', function(event) {
          Backbone.history.navigate('classrooms/' + model.classroom.classroomId, {
            trigger: true
          });
          return event.preventDefault();
        });
        return this;
      }
    });
    return ClassroomPreviewView;
  });

}).call(this);

/*
//@ sourceMappingURL=classroom-preview-view.js.map
*/