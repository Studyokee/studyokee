define [
  'media.item.view',
  'backbone',
  'handlebars',
  'templates'
], (MediaItemView, Backbone, Handlebars) ->
  MediaItemListView = Backbone.View.extend(
    className: "mediaItemList"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.initItemViews(this.model.get('data'))
        this.render()
      )
      this.initItemViews(this.model.get('data'))

    render: () ->
      if this.model.get('isLoading')
        this.$el.html(Handlebars.templates['spinner']())
      else
        if this.mediaItemViews.length > 0
          this.$el.html(Handlebars.templates['media-item-list'](this.mediaItemViews))
          links = this.$('.mediaItemLink')
          for i in [0..links.length - 1]
            $(links[i]).html(this.mediaItemViews[i].render().el)
          
          view = this
          this.$('.mediaItemLink').on('click', (event) ->
            data = view.model.get('data')
            index = $(this).attr('data-index')
            view.trigger('select', data[index])
          )
        else
          this.$el.html(Handlebars.templates['no-items']())

      return this

    initItemViews: (data) ->
      this.mediaItemViews = []
      if data and data.length > 0
        for item in data
          mediaItemView = new MediaItemView(
            model: new Backbone.Model(
              data: item
            )
          )
          this.mediaItemViews.push(mediaItemView)


  )

  return MediaItemListView