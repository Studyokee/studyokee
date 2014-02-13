define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  CreateClassroomView = Backbone.View.extend(
    className: "create-classroom"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['create-classroom']())

      view = this
      this.$('.cancel').on('click', (event) ->
        document.location = '/'
        event.preventDefault()
      )
      this.$('.save').on('click', (event) =>
        name = this.$('#name').val()
        language = this.$('#language').val()
        success = (classroom) ->
          document.location = '/classroom/' + classroom.classroomId
        this.model.saveClassroom(name, language, success)
        event.preventDefault()
      )

      return this

  )

  return CreateClassroomView