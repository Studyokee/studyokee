define [
  'backbone',
  'handlebars',
  'jquery.ui.effect',
  'bootstrap',
  'templates'
], (Backbone, Handlebars) ->
  HeaderView = Backbone.View.extend(
    tagName: "header"
    
    initialize: (options) ->
      this.options = options

      this.listenTo(this.model, 'change:vocabularyCount', () ->
        console.log('animate change')
        vocabularyCount = this.model.get('vocabularyCount')
        badge = $('.vocabulary-link .badge')

        if vocabularyCount > 0
          badge.show()

        badge.html(vocabularyCount)
        badge.addClass('throb')
        remove = () ->
          badge.removeClass('throb')
        setTimeout(remove, 1000)

        if vocabularyCount is 0
          hide = () ->
            badge.hide()
          setTimeout(hide, 1000)
      )

      this.listenTo(this.model, 'change:user', () =>
        this.render()
      )

    render: () ->
      console.log('render header')
      this.$el.html(Handlebars.templates['header'](this.model.toJSON()))
      
      this.$('[data-toggle="popover"]').popover()
      
      $('.userInfoDrawer').on('shown.bs.popover', () =>
        this.$('.updateUser').click(() =>
          this.$('.updateUser').html('Saving...')
          updates = {}
          displayName = $('#displayName').val()
          username = $('#username').val()
          password = $('#password').val()

          if (displayName)
            updates.displayName = displayName
          if (username)
            updates.username = username
          if (password)
            updates.password = password
          callback = () ->
            this.$('.updateUser').html('Update')
          this.model.updateUser(updates, callback)
        )
        this.$('.closeUpdateUser').click(() =>
          $('.userInfoDrawer').popover('hide')
        )
      )

      if this.options.sparse
        this.$('.navbar-left').hide()

      return this
  )

  return HeaderView