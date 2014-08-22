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
        view.trigger('cancel')
        event.preventDefault()
      )
      this.$('.save').on('click', (event) =>
        newSong =
          metadata:
            trackName: this.$('#trackName').val()
            artist: this.$('#artist').val()
            language: this.$('#language').val()
          youtubeKey: $.url(this.$('#youtubeKey').val()).param('v')
        success = (savedSong) ->
          view.trigger('saveSuccess', savedSong)
        this.model.saveSong(newSong, success)
        event.preventDefault()
      )

      defaultLanguage = this.model.get('defaultLanguage')
      if defaultLanguage?
        this.$('#language').val(defaultLanguage)
        
      return this

  )

  return CreateSongView