define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  HomeView = Backbone.View.extend(
    className: "home"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['home'](this.model.toJSON()))

      view = this
      this.$('.classroomLink').on('click', () ->
        classrooms = view.model.get('data')
        index = $(this).attr('data-index')
        view.openClassroom(classrooms[index])
      )

      this.$('.createClassroom').on('click', (event) =>
        document.location = '/classrooms/create'
      )

      return this

    openClassroom: (classroom) ->
      document.location = '/classrooms/' + classroom.classroomId


  )

  return HomeView