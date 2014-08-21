define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  EditSongsView = Backbone.View.extend(
    className: "editSongs"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['edit-songs'](this.model.toJSON()))

      view = this
      this.$('.remove').on('click', () ->
        if confirm('Delete this song?')
          songs = view.model.get('data')
          index = $(this).attr('data-index')
          view.model.deleteSong(songs[index])
      )
      this.$('.open').on('click', () ->
        songs = view.model.get('data')
        index = $(this).attr('data-index')
        view.openSong(songs[index])
      )

      return this

    openSong: (song) ->
      document.location = '../../songs/' + song._id + '/edit'

  )

  return EditSongsView