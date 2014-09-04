define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  CreateClassroomView = Backbone.View.extend(
    className: "create-classroom container"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['create-classroom'](this.model.get('settings').toJSON()))

      view = this
      this.$('.cancel').on('click', (event) ->
        Backbone.history.navigate('/', {trigger: true})
        event.preventDefault()
      )
      this.$('.save').on('click', (event) =>
        name = this.$('#name').val()
        language = this.$('#language').val()
        success = (classroom) ->
          Backbone.history.navigate('/classrooms/' + classroom.classroomId + '/edit', {trigger: true})
        this.model.saveClassroom(name, language, success)
        event.preventDefault()
      )
      this.$('#language').val(this.model.get('settings').get('fromLanguage').language)

      return this

  )

  return CreateClassroomView