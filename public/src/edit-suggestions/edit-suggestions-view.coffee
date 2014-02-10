define [
  'add.song.view',
  'suggestions.view',
  'backbone',
  'handlebars',
  'templates'
], (AddSongView, SuggestionsView, Backbone, Handlebars) ->

  EditSuggestionsView = Backbone.View.extend(
    tagName:  "div"
    className: "editSuggestions"
    
    initialize: () ->

      this.suggestionsView = new SuggestionsView(
        model: this.model.suggestionsModel
      )

      this.listenTo(this.suggestionsView, 'select', (song) =>
        if not song?.song?
          return

        document.location = '../../songs/edit/' + song.song._id
      )

    render: () ->
      this.$el.html(Handlebars.templates['edit-suggestions'](this.model.toJSON()))

      this.$('.songListContainer').html(this.suggestionsView.render().el)

      this.$('.add').on('click', (event) =>
        songToAddElement = $('#songToAdd')
        id = songToAddElement.val()
        this.model.addSong(id)
        songToAddElement.val('')
        event.preventDefault()
      )

      return this

  )

  return EditSuggestionsView