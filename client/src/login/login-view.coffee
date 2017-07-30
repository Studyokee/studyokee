define [
  'backbone',
  'handlebars',
  'purl',
  'templates'
], (Backbone, Handlebars, Purl) ->
  LoginView = Backbone.View.extend(
    className: "container"
    
    initialize: () ->

    render: () ->
      this.$el.html(Handlebars.templates['login'](this.model.toJSON()))

      # if this is a redirect, try logging in from cookies and redirect
      params = $.url(document.location).param()
      # if params.redirectUrl?
      #   username = this.readCookie('username')
      #   password = this.readCookie('password')
      #   if username? and password?
      #     this.$('.mask').show()
      #     this.login(username, password)

      this.$('#login').on('submit', (event) =>
        username = this.$('#username').val()
        password = this.$('#password').val()
        this.login(username, password)

        event.preventDefault()
      )

      return this

    login: (username, password) ->
      user =
        username: username
        password: password
      $.ajax(
        type: 'POST'
        url: '/login'
        data: user
        success: (response) =>
          console.log('Success!')
          params = $.url(document.location).param()
          redirectUrl = '/classrooms/language/es/en'
          if params.redirectUrl?
            redirectUrl = params.redirectUrl + document.location.hash
          this.setCookie('username', username)
          this.setCookie('password', password)
          document.location = redirectUrl
        error: (err) =>
          console.log('Error: ' + err.responseText)
          this.$('.login-mask').hide()
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

  return LoginView