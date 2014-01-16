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

      this.addSongView = new AddSongView(
        model: this.model.addSongModel
      )
      this.suggestionsView = new SuggestionsView(
        model: this.model.suggestionsModel
      )

      this.listenTo(this.suggestionsView, 'select', (song) =>
        if not song?
          return

        document.location = '../../songs/' + song.key + '/' + this.model.get('toLanguage')
      )

    render: () ->
      this.$el.html(Handlebars.templates['edit-suggestions'](this.model.toJSON()))

      this.$('.searchContainer').html(this.addSongView.render().el)
      this.$('.songListContainer').html(this.suggestionsView.render().el)

      return this

  )

  return EditSuggestionsView