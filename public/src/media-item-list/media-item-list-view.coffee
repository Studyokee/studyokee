define [
  'media.item.view',
  'backbone',
  'handlebars',
  'jquery.ui.sortable',
  'templates'
], (MediaItemView, Backbone, Handlebars) ->
  MediaItemListView = Backbone.View.extend(
    className: "mediaItemList"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        newItems = this.model.get('data')
        oldIds = []
        this.$('li').each(() ->
          oldIds.push($(this).attr('data-id'))
        )

        noChange = true
        if newItems.length is oldIds.length
          for i in [0...newItems.length]
            if newItems[i]?.song?._id isnt oldIds?[i]
              noChange = false
              break
        else
          noChange = false

        # only rerender if list of ids changed
        if noChange
          return

        this.initItemViews(newItems)
        this.render()
      )
      this.initItemViews(this.model.get('data'))

    render: () ->
      if this.model.get('isLoading')
        this.$el.html(Handlebars.templates['spinner']())
      else
        if this.mediaItemViews.length > 0
          if this.options.readonly
            this.$el.html(Handlebars.templates['media-item-list-readonly'](this.mediaItems))
          else
            this.$el.html(Handlebars.templates['media-item-list'](this.mediaItems))

          links = this.$('.mediaItemLink')
          for i in [0..links.length - 1]
            $(links[i]).html(this.mediaItemViews[i].render().el)
          
          view = this
          this.$('.mediaItemLink').on('click', (event) ->
            data = view.model.get('data')
            index = $(this).parent('li').attr('data-index')
            view.trigger('select', data[index])
          )

          this.$('.remove').on('click', (event) ->
            data = view.model.get('data')
            index = $(this).parent('li').attr('data-index')
            view.trigger('remove', data[index])
          )
          this.$('.view').on('click', (event) ->
            data = view.model.get('data')
            index = $(this).parent('li').attr('data-index')
            view.trigger('view', data[index])
          )

          if this.model.get('allowActions')
            this.$('.remove').show()
            this.$('.view').show()
          else
            this.$('.remove').hide()
            this.$('.view').hide()
        else
          this.$el.html(Handlebars.templates['no-items']())

      if not this.options.readonly
        sortableList = this.$('ul')
        ids = []
        this.$('li').each(() ->
          ids.push($(this).attr('data-id'))
        )
        options =
          update: (event, ui) =>
            ids = []
            this.$('li').each(() ->
              ids.push($(this).attr('data-id'))
            )
            this.trigger('reorder', ids)

        sortableList.sortable(options)
        sortableList.disableSelection()
      return this

    initItemViews: (data) ->
      this.mediaItemViews = []
      this.mediaItems = []
      if data and data.length > 0
        for item in data
          mediaItemView = new MediaItemView(
            model: new Backbone.Model(
              data: item
            )
          )
          this.mediaItemViews.push(mediaItemView)
          this.mediaItems.push(item)


  )

  return MediaItemListView