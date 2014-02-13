require [
  'edit.songs.model',
  'edit.songs.view',
  'jquery'
], (EditSongsModel, EditSongsView, $) ->

  model = new EditSongsModel()

  view = new EditSongsView(
    model: model
  )
  $('.skee').html(view.render().el)