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
      ###this.listenTo(this.model, 'change', () =>
        console.log('on change header')
        this.render()
      )###

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

    render: () ->
      console.log('render header')
      this.$el.html(Handlebars.templates['header'](this.model.toJSON()))

      this.$('.createClassroom').on('click', (event) =>
        Backbone.history.navigate('classrooms/create', {trigger: true})
        event.preventDefault()
      )
      this.$('.openClassrooms').on('click', (event) =>
        Backbone.history.navigate('classrooms/language/' + this.model.get('fromLanguage') + '/en', {trigger: true})
        event.preventDefault()
      )
      this.$('.navbar-brand').on('click', (event) =>
        Backbone.history.navigate('', {trigger: true})
        event.preventDefault()
      )
      this.$('.vocabulary').on('click', (event) =>
        Backbone.history.navigate('vocabulary/' + this.model.get('fromLanguage') + '/en', {trigger: true})
        event.preventDefault()
      )
      this.$('.login').on('click', (event) =>
        document.location = '/auth/facebook?callbackURL=' + Backbone.history.location.pathname
        event.preventDefault()
      )

      ###view = this
      this.$('.selectLanguage .dropdown-menu a').on('click', (event) ->
        index = $(this).attr('data-index')
        currentLanguage = view.model.get('supportedLanguages')[index]
        view.$('.selectLanguage .currentLanguage').html(currentLanguage.display)
        view.model.setFromLangauge(currentLanguage.language)
        Backbone.history.navigate('classrooms/language/' + currentLanguage.language + '/en', {trigger: true})
        event.preventDefault()
      )
      this.$('.selectLanguage .dropdown-toggle .languageIcon').addClass(this.model.get('fromLanguage').language)
      ###
      if this.options.sparse
        this.$('.navbar-left').hide()

      return this
  )

  return HeaderView