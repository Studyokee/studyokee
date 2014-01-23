define [
  'media.item.view',
  'backbone',
  'handlebars',
  'templates'
], (MediaItemView, Backbone, Handlebars) ->

  RdioPlayerView = Backbone.View.extend(
    tagName:  "div"
    className: "rdioPlayer"
    
    initialize: () ->
      this.mediaItemView = new MediaItemView(
        model: new Backbone.Model(
          data: this.model.get('currentSong')
        )
      )

      this.listenTo(this.model, 'change:currentSong', () =>
        this.mediaItemView.model.set(
          data: this.model.get('currentSong')
        )
      )

    render: () ->
      this.$el.html(Handlebars.templates['rdio-player'](this.model.toJSON()))
      this.$('.mediaItemContainer').html(this.mediaItemView.render().el)

      return this

  )

  return RdioPlayerView