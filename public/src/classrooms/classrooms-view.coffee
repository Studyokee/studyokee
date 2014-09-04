define [
  'backbone',
  'classroom.preview.model',
  'classroom.preview.view',
  'pagination.view',
  'handlebars',
  'templates'
], (Backbone, ClassroomPreviewModel, ClassroomPreviewView, PaginationView, Handlebars) ->
  ClassroomsView = Backbone.View.extend(
    className: "classrooms container"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )
      this.paginationViewBottom = new PaginationView(
        model: this.model.paginationModel
      )
      this.paginationViewBottom.on('openPage', (pageToGet) =>
        this.model.getClassrooms(pageToGet)
      )

    render: () ->
      this.$el.html(Handlebars.templates['classrooms'](this.model.toJSON()))

      this.$('.paginationContainerBottom').html(this.paginationViewBottom.render().el)
      if this.model.get('data')?
        classrooms = this.model.get('data')
        for classroom in classrooms
          songs = null
          classroomPreviewView = new ClassroomPreviewView(
            model: new ClassroomPreviewModel(
              classroom: classroom
            )
          )
          this.$('.classroomPreviewViews').append(classroomPreviewView.render().el)

      return this
  )

  return ClassroomsView