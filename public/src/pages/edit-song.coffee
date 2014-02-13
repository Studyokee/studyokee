require [
  'edit.song.model',
  'edit.song.view',
  'jquery'
], (EditSongModel, EditSongView, $) ->

  dataElement = $('#data-dom')
  id = dataElement.attr('data-id')
  model = new EditSongModel(
    id: id
  )

  view = new EditSongView(
    model: model
  )
  $('.skee').html(view.render().el)