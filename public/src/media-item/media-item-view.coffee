define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  MediaItemView = Backbone.View.extend(
    className: "mediaItem"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['media-item'](this.model.toJSON()))
      if not this.model.get('data')?.icon?
        this.$('.icon').hide()
      else
        this.$('.song').show()

      return this

  )

  return MediaItemView