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

      if not this.model.get('data')?.icon
        this.$('.icon').toggle()

      centerImage = () =>
        this.centerImage()
      setTimeout(centerImage)

      return this

    centerImage: () ->
      outerWrapper = this.$('.icon')
      img = this.$('.icon img')
      croppedImageWidth = outerWrapper.width()
      fullImageWidth = img.width()
      extraWidth = fullImageWidth - croppedImageWidth
      leftMargin = Math.abs(extraWidth/2)
      img.css('margin-left', -leftMargin + 'px')

  )

  return MediaItemView