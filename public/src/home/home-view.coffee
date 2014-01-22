define [
  'header.view',
  'backbone',
  'handlebars',
  'templates'
], (HeaderView, Backbone, Handlebars) ->
  HomeView = Backbone.View.extend(
    tagName:  "div"
    className: "home"
    
    initialize: () ->
      this.headerView = new HeaderView()

      this.headerView.on('toggleMenu', () =>
        if this.mainView
          this.mainView.trigger('toggleMenu')
      )

    render: () ->
      this.$el.html(this.headerView.render().el)
      if this.mainView
        this.$el.append(this.mainView.render().el)
      this.$el.append(Handlebars.templates['footer']())

      return this

  )

  return HomeView