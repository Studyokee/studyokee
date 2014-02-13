require [
  'create.classroom.model',
  'create.classroom.view',
  'jquery'
], (CreateClassroomModel, CreateClassroomView, $) ->

  model = new CreateClassroomModel()
  view = new CreateClassroomView(
    model: model
  )
  $('.skee').html(view.render().el)