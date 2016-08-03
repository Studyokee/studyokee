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

      this.$('#submit').on('click', (event) =>
        username = this.$('#username').val()
        password = this.$('#password').val()
        
        this.signup(username, password, $.url(document.location).param().redirectUrl)

        event.preventDefault()
      )

      return this

    signup: (username, password, redirectUrl) ->
      user =
        username: username
        password: password
      $('.registerWarning .alert').alert('close')
      $.ajax(
        type: 'POST'
        url: '/signup'
        data: user
        success: (response, s, t) =>
          if redirectUrl
            document.location = redirectUrl
          else
            document.location = '/classrooms/1'
        error: (err) =>
          if err.responseText.indexOf('User already exists') > 0
            $('.registerWarning').html(this.getAlert('Username already exists!'))
          else if err.responseText.indexOf('User signup limit') > 0
            $('.registerWarning').html(this.getAlert('User signup limit reached!'))
            
      )

    getAlert: (text) ->
      return '<div class="alert alert-warning alert-dismissible fade in" role="alert"> <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button> ' + text + '</div>'
  )

  return SignupView