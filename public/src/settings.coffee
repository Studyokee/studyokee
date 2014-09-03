define [
  'backbone'
], (Backbone) ->
  SettingsModel = Backbone.Model.extend(
    defaults:
      enableLogging: true
      defaultToLanguage: {'language': 'en', 'display': 'English'}
      defaultFromLanguage: {'language': 'es', 'display': 'Spanish'}
      toLanguage: {'language': 'en', 'display': 'English'}
      fromLanguage: {'language': 'es', 'display': 'Spanish'}
      userId: null
      supportedLanguages: [
        {'language': 'es', 'display': 'Spanish'},
        {'language': 'fr', 'display': 'French'},
        {'language': 'de', 'display': 'German'},
      ]

    setFromLangauge: (language) ->
      languages = this.get('supportedLanguages')
      for item in languages
        if item.language is language
          this.set(
            fromLanguage: item
          )
          return
  )

  return SettingsModel
