require [
  'create.song.model',
  'create.song.view',
  'jquery'
], (CreateSongModel, CreateSongView, $) ->

  model = new CreateSongModel()
  view = new CreateSongView(
    model: model
  )
  $('.skee').html(view.render().el)