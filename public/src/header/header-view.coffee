define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  HeaderView = Backbone.View.extend(
    tagName:  "div"
    className: "header"
    
    render: () ->
      this.$el.html(Handlebars.templates['header']())

      this.$('.toggleMenu').on('click', () =>
        this.trigger('toggleMenu')
      )

      return this
  )

  return HeaderView