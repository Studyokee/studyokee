define [
  'header.view',
  'dictionary.view',
  'backbone',
  'handlebars',
  'templates'
], (HeaderView, DictionaryView, Backbone, Handlebars) ->
  HomeView = Backbone.View.extend(
    tagName:  "div"
    className: "home"
    
    initialize: () ->
      this.headerView = new HeaderView()

      this.headerView.on('toggleMenu', () =>
        this.trigger('toggleMenu')
      )

      this.dictionaryView = new DictionaryView(
        model: this.model.dictionaryModel
      )

      this.on('lookup', (query) =>
        this.model.lookup(query)
        this.$('.dictionaryContainer').addClass('active')

        this.dictionaryView.on('close', () =>
          this.$('.dictionaryContainer').removeClass('active')
        )
      )

      this.on('toggleMenu', () =>
        this.$('.menu').toggleClass('active')
      )

    render: () ->
      this.$el.html(Handlebars.templates['home'](this.model.toJSON()))

      this.$('.headerContainer').html(this.headerView.render().el)

      if this.menuView
        this.$('.menu').html(this.menuView.render().el)
      if this.mainView
        this.$('.center').append(this.mainView.render().el)

      this.$('.dictionaryContainer').html(this.dictionaryView.render().el)

      return this

  )

  return HomeView