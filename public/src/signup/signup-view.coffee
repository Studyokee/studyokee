define [
  'backbone',
  'handlebars',
  'purl',
  'templates'
], (Backbone, Handlebars, Purl) ->
  SignupView = Backbone.View.extend(
    className: "container"
    
    initialize: () ->

    render: () ->
      this.$el.html(Handlebars.templates['signup'](this.model.toJSON()))

      # if this is special register url, auto create user
      # /signup?redirectUrl={{url}}&username={{username}}&password={{pw}}
      params = $.url(document.location).param()
      if params.redirectUrl? and params.username? and params.password?
        if username? and password?
          this.$('.mask').show()
          this.signup(params.username, params.password)

      this.$('#submit').on('click', (event) =>
        username = this.$('#username').val()
        password = this.$('#password').val()
        
        this.signup(username, password)

        event.preventDefault()
      )

      return this

    signup: (username, password) ->
      user =
        username: username
        password: password
      $.ajax(
        type: 'POST'
        url: '/signup'
        data: user
        success: () =>
          console.log('Success!')
          params = $.url(document.location).param()
          redirectUrl = '/'
          if params.redirectUrl?
            redirectUrl = params.redirectUrl
          document.location = redirectUrl
        error: (err) =>
          console.log('Error: ' + err.responseText)
      )
  )

  return SignupView