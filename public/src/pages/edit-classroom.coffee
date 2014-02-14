require [
  'edit.classroom.model',
  'edit.classroom.view',
  'jquery'
], (EditClassroomModel, EditClassroomView, $) ->

  dataElement = $('#data-dom')
  id = dataElement.attr('data-id')
  model = new EditClassroomModel(
    id: id
  )
  view = new EditClassroomView(
    model: model
  )
  $('.skee').html(view.render().el)