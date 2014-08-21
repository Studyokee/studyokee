define [
  'backbone',
  'handlebars',
  'jquery',
  'purl',
  'templates'
], (Backbone, Handlebars, $) ->
  CreateSongView = Backbone.View.extend(
    className: "create-Song"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['create-song']())

      view = this
      this.$('.cancel').on('click', (event) ->
        window.history.back()
        event.preventDefault()
      )
      this.$('.save').on('click', (event) =>
        trackName = this.$('#trackName').val()
        artist = this.$('#artist').val()
        language = this.$('#language').val()
        success = (song) ->
          document.location = '/songs/' + song._id + '/edit'
        this.model.saveSong(trackName, artist, language, success)
        event.preventDefault()
      )

      defaultLanguage = $.url().param('language')
      if defaultLanguage?
        this.$('#language').val(defaultLanguage)
        
      return this

  )

  return CreateSongView