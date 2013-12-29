define [
  'backbone'
  'handlebars',
  'song.list.view',
  'templates'
], (Backbone, Handlebars, SongListView) ->

  SuggestionsView = Backbone.View.extend(
    tagName:  "div"
    className: "suggestions"

    initialize: () ->
      this.songListView = new SongListView(
        model: this.model
      )

      this.songListView.on('select', (song) =>
        this.model.set(
          selectedSong: song
        )
      )

      this.listenTo(this.model, 'change:songs', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['suggestions'](this.model.toJSON()))
      this.$('.songListContainer').html(this.songListView.render().el)

      return this
  )

  return SuggestionsView