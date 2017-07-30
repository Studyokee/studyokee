define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  PaginationView = Backbone.View.extend(
    className: "pagination"
    tagName: "ul"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      count = this.model.get('count')
      currentPage = this.model.get('currentPage')
      pageSize = this.model.get('pageSize')
      pageCount = Math.ceil(count/pageSize)

      this.$el.html(Handlebars.templates['pagination'](this.model))

      if pageCount < 2
        this.$el.hide()
        return this
      else
        this.$el.show()

      list = ''
      for index in [0..pageCount-1]
        li = '<li'
        if index is currentPage
          li += ' class="active"'
        li += '><a href="#" class="selectPage">' + (index+1) + '</a></li>'
        list += li

      this.$('.prevPage').after(list)

      view = this
      this.$('.selectPage').on('click', (event) ->
        index = parseInt($(this).html() - 1)
        view.trigger('openPage', index)
        event.preventDefault()
      )

      if currentPage is 0
        this.$('.prevPage').addClass('disabled')
      else
        this.$('.prevPage').on('click', (event) =>
          this.trigger('openPage', this.model.get('currentPage') - 1)
          event.preventDefault()
        )

      if currentPage is (pageCount-1)
        this.$('.nextPage').addClass('disabled')
      else
        this.$('.nextPage').on('click', (event) =>
          this.trigger('openPage', this.model.get('currentPage') + 1)
          event.preventDefault()
        )

      return this

  )

  return PaginationView