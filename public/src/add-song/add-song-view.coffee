define [
  'backbone',
  'song.list.view'
], (Backbone, SongListView) ->
  AddSongView = Backbone.View.extend(
    tagName:  "div"
    className: "addSong"
    
    initialize: () ->
      this.acView = new SongListView(
        model: this.model
      )

      this.acView.on('select', (suggestion) =>
        this.model.set(
          songs: []
          showAC: false
        )
        this.$('.search').val('')
        this.model.trigger('select', suggestion)
      )

      this.listenTo(this.model, 'change:showAC', () =>
        if this.model.get('showAC')
          this.$('.acContainer').show()
        else
          this.$('.acContainer').hide()
      )

    render: () ->
      this.$el.html(Handlebars.templates['add-song']())
      this.$('.acContainer').html(this.acView.render().el)

      this.$('.search').on('keyup', () =>
        this.search()
      )
      this.$('.search').on('focus', () =>
        fn = (event) =>
          target = $(event.target)
          if target.parents('.addSong').length is 0
            this.model.set(
              showAC: false
            )
            $(window).unbind('click', fn)

        $(window).on('click', fn)
      )

      return this

    search: () ->
      query = this.$('.search').val().trim()
      console.log('Prepare to do search: ' + query)
      this.lastSearch = query
      delayedFn = () =>
        if query isnt this.lastSearch
          return

        this.model.search(query)
      setTimeout(delayedFn, 50)

  )

  return AddSongView