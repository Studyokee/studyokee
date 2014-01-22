define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  AutocompleteView = Backbone.View.extend(
    tagName:  "div"
    className: "songList"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      if this.model.get('isLoading')
        this.$el.html(Handlebars.templates['spinner']())
      else
        songs = this.model.get('songs')
        if songs and songs.length > 0
          data =
            songs: songs.slice(0, 10)
          this.$el.html(Handlebars.templates['song-list'](data))

          view = this
          this.$('.song').on('click', (event) ->
            index = $(this).attr('data-index')
            view.trigger('select', songs[index])
          )
        else
          this.$el.html(Handlebars.templates['no-songs']())

      return this

  )

  return AutocompleteView