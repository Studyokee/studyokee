define [
  'backbone',
  'autocomplete.view'
], (Backbone, AutocompleteView) ->
  AddSongView = Backbone.View.extend(
    tagName:  "div"
    className: "addSong"
    
    initialize: () ->
      this.acView = new AutocompleteView(
        model: this.model
      )

      this.acView.on('select', (suggestion) =>
        console.log('select asv')
        this.model.set(
          suggestions: []
        )
        this.$('.search').val('')
        this.model.trigger('select', suggestion)
      )
      this.listenTo(this.model, 'change:suggestions', () =>
        suggestions = this.model.get('suggestions')
        if suggestions and suggestions.length > 0
          this.showAC()
        else
          this.hideAC()
      )

    render: () ->
      this.$el.html(Handlebars.templates['add-song']())
      suggestions = this.model.get('suggestions')
      if suggestions and suggestions.length > 0
        this.showAC()

      onKeyUp = () =>
        query = this.$('.search').val().trim()
        console.log('Prepare to do search: ' + query)
        this.lastSearch = query
        searchFn = () =>
          if query isnt this.lastSearch
            return

          this.model.search(query)
        setTimeout(searchFn, 50)
      this.$('.search').on('keyup', onKeyUp)

      return this

    showAC: () ->
      this.$('.acContainer').html(this.acView.render().el)

    hideAC: () ->
      this.$('.acContainer').html('')

  )

  return AddSongView