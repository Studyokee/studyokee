define [
  'backbone',
  'handlebars',
  'purl',
  'templates'
], (Backbone, Handlebars, Purl) ->
  LoginView = Backbone.View.extend(
    className: "login container"
    
    initialize: () ->

    render: () ->
      this.$el.html(Handlebars.templates['login'](this.model.toJSON()))

      this.$('.login').on('click', (event) =>
        params = $.url(document.location).param()
        document.location = '/auth/facebook?callbackURL=' + params.callbackURL
        event.preventDefault()
      )

      return this
  )

  return LoginView