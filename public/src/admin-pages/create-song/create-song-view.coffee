define [
  'backbone',
  'handlebars',
  'jquery',
  'purl',
  'templates'
], (Backbone, Handlebars, $) ->
  CreateSongView = Backbone.View.extend(
    className: "createSong"
    
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
        fields =
          trackName: this.$('#trackName').val()
          artist: this.$('#artist').val()
          youtubeKey: $.url(this.$('#youtubeKey').val()).param('v')
        success = (savedSong) ->
          view.trigger('saveSuccess', savedSong)
        this.model.saveSong(fields, success)
        event.preventDefault()
      )

      populateFields = (rawTitle) =>
        artist = ''
        trackName = ''

        if rawTitle && rawTitle.indexOf
          split = rawTitle.indexOf('-')
          if split >= 0
            artist = rawTitle.substr(0, split)
            trackName = rawTitle.substr(split + 1)
          else
            trackName = rawTitle

        if not this.$('#artist').val()
          this.$('#artist').val($.trim(artist))

        if not this.$('#trackName').val()
          this.$('#trackName').val($.trim(trackName))

      this.$('#youtubeKey').on('keyup', () =>
        url = this.$('#youtubeKey').val()
        id = url.substr(url.indexOf('=') + 1)
        this.model.getSongDetails(id, populateFields)
      )
        
      return this

  )

  return CreateSongView