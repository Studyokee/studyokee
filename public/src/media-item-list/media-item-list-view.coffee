define [
  'media.item.view',
  'backbone',
  'handlebars',
  'jquery.ui.sortable',
  'templates'
], (MediaItemView, Backbone, Handlebars) ->
  MediaItemListView = Backbone.View.extend(
    className: "mediaItemList"
    
    initialize: (options) ->
      this.options = options
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
      this.listenTo(this.model, 'change:isLoading', () =>
        this.render()
      )
      this.initItemViews(this.model.get('data'))

    render: () ->
      if this.model.get('isLoading')
        this.$el.html(Handlebars.templates['spinner']())
      else
        if this.mediaItemViews.length > 0
          renderData =
            mediaItems: this.mediaItems
            hasMoreItems: this.hasMoreItems
          if this.options.readonly
            this.$el.html(Handlebars.templates['media-item-list-readonly'](renderData))
          else
            this.$el.html(Handlebars.templates['media-item-list'](renderData))

          links = this.$('.mediaItemLink')
          for i in [0..links.length - 1]
            $(links[i]).html(this.mediaItemViews[i].render().el)
          
          if this.options.allowSelect
            this.$('li:first').addClass('active')

          view = this
          this.$('.mediaItemLink').on('click', (event) ->
            data = view.model.get('data')
            li = $(this).parent('li')
            index = li.attr('data-index')
            view.trigger('select', data[index])

            if view.options.allowSelect
              view.$('li.active').removeClass('active')
              li.addClass('active')
          )

          if this.options.allowActions
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
            this.$('.remove').show()
            this.$('.view').show()
          else
            this.$('.remove').hide()
            this.$('.view').hide()
        else
          this.$el.html(Handlebars.templates['no-items']())

      if this.options.allowReorder
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
      this.hasMoreItems = false
      this.mediaItemViews = []
      this.mediaItems = []
      if data and data.length > 0
        numItems = data.length
        if this.options.limit
          numItems = Math.min(this.options.limit, data.length)
          if data.length > this.options.limit
            this.hasMoreItems = true
          
        for index in [0..numItems-1]
          item = data[index]
          mediaItemView = new MediaItemView(
            model: new Backbone.Model(
              data: item
            )
          )
          this.mediaItemViews.push(mediaItemView)
          this.mediaItems.push(item)


  )

  return MediaItemListView