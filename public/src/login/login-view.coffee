define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  LoginView = Backbone.View.extend(
    className: "login container"
    
    initialize: () ->

    render: () ->
      this.$el.html(Handlebars.templates['login'](this.model.toJSON()))

      return this
  )

  return LoginView