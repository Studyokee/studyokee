define [
  'backbone',
  'handlebars',
  'bootstrap',
  'templates'
], (Backbone, Handlebars) ->
  HeaderView = Backbone.View.extend(
    tagName: "header"
    
    initialize: (options) ->
      this.options = options
      this.listenTo(this.model, 'change', () =>
        console.log('on change header')
        this.render()
      )

    render: () ->
      console.log('render header')
      this.$el.html(Handlebars.templates['header'](this.model.toJSON()))

      this.$('.createClassroom').on('click', (event) =>
        document.location = '/classrooms/create'
        event.preventDefault()
      )
      this.$('.openClassrooms').on('click', (event) =>
        document.location = 'classrooms/language/' + this.model.get('fromLanguage').language + '/en'
        event.preventDefault()
      )
      this.$('.navbar-brand').on('click', (event) =>
        document.location = ''
        event.preventDefault()
      )

      view = this
      this.$('.selectLanguage .dropdown-menu a').on('click', (event) ->
        index = $(this).attr('data-index')
        currentLanguage = view.model.get('supportedLanguages')[index]
        view.$('.selectLanguage .currentLanguage').html(currentLanguage.display)
        view.model.setFromLangauge(currentLanguage.language)
        document.location = 'classrooms/language/' + currentLanguage.language + '/en'
        event.preventDefault()
      )
      this.$('.selectLanguage .dropdown-toggle .languageIcon').addClass(this.model.get('fromLanguage').language)

      if this.options.sparse
        this.$('.navbar-left').hide()

      return this
  )

  return HeaderView