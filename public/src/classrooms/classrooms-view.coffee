define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  ClassroomsView = Backbone.View.extend(
    className: "classrooms"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['classrooms'](this.model.toJSON()))

      view = this
      this.$('.classroomLink').on('click', () ->
        classrooms = view.model.get('data')
        index = $(this).attr('data-index')
        view.openClassroom(classrooms[index])
      )

      return this

    openClassroom: (classroom) ->
      document.location = '/classrooms/' + classroom.classroomId
  )

  return ClassroomsView