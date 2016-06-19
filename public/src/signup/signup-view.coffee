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
        success: (response, s, t) =>
          console.log('Success!')
          this.setCookie('username', username)
          this.setCookie('password', password)
          document.location = '/classrooms/language/es/en'
        error: (err, t, s) =>
          console.log('Error: ' + err.responseText)
      )

    readCookie: (name) ->
      nameEQ = name + '='
      ca = document.cookie.split(';')
      for c in ca
        while c.charAt(0) is ' '
          c = c.substring(1,c.length)
        if c.indexOf(nameEQ) is 0
          return c.substring(nameEQ.length,c.length)
      
      return null

    setCookie: (name, value) ->
      document.cookie = name + '=' + value + '; Path=/;'

    deleteCookie: (name) ->
      document.cookie = name +'=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;'
  )

  return SignupView