define [
  'backbone',
  'classroom.preview.model',
  'classroom.preview.view',
  'handlebars',
  'templates'
], (Backbone, ClassroomPreviewModel, ClassroomPreviewView, Handlebars) ->
  HomeView = Backbone.View.extend(
    className: "home"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      model = this.model.toJSON()

      this.$el.html(Handlebars.templates['home'](model))

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

      this.$('.createClassroom').on('click', (event) =>
        Backbone.history.navigate('classrooms/create', {trigger: true})
      )

      return this
  )

  return HomeView