define [
  'backbone',
  'handlebars',
  'bootstrap',
  'templates'
], (Backbone, Handlebars) ->
  HeaderView = Backbone.View.extend(
    className: "header"
    
    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['header'](this.model.toJSON()))

      this.$('.createClassroom').on('click', (event) =>
        Backbone.history.navigate('classrooms/create', {trigger: true})
        event.preventDefault()
      )

      view = this
      this.$('.selectLanguage .dropdown-menu a').on('click', (event) ->
        index = $(this).attr('data-index')
        currentLanguage = view.model.get('supportedLanguages')[index]
        view.$('.selectLanguage .currentLanguage').html(currentLanguage.display)
        view.model.setFromLangauge(currentLanguage.language)
        Backbone.history.navigate('classrooms/' + currentLanguage.language + '/en', {trigger: true})
        event.preventDefault()
      )
      this.$('.selectLanguage .currentLanguage').html(this.model.get('fromLanguage').display)

      return this
  )

  return HeaderView