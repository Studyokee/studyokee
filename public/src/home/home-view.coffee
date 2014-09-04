define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  HomeView = Backbone.View.extend(
    className: "home"
    
    initialize: () ->

    render: () ->
      this.$el.html(Handlebars.templates['home'](this.model.get('settings').toJSON()))

      view = this
      this.$('.languageLink').on('click', (event) ->
        index = $(this).attr('data-index')
        currentLanguage = view.model.get('settings').get('supportedLanguages')[index]
        view.$('.selectLanguage .currentLanguage').html(currentLanguage.display)
        view.model.get('settings').setFromLangauge(currentLanguage.language)
        Backbone.history.navigate('classrooms/' + currentLanguage.language + '/en', {trigger: true})
        event.preventDefault()
      )

      return this
  )

  return HomeView