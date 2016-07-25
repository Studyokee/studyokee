define [
  'backbone'
], (Backbone) ->
  toLanguages = [
    {'language': 'en', 'display': 'English'}
  ]
  fromLanguages = [
    {'language': 'es', 'display': 'Spanish'},
    {'language': 'fr', 'display': 'French'},
    {'language': 'pt', 'display': 'Portuguese'}
  ]
  SettingsModel = Backbone.Model.extend(
    defaults:
      enableLogging: true
      defaultToLanguage: toLanguages[0]
      defaultFromLanguage: fromLanguages[0]
      toLanguage: toLanguages[0]
      fromLanguage: fromLanguages[0]
      user:
        id: ''
        displayName: ''
        username: ''
        admin: false
      supportedLanguages: fromLanguages

    setFromLangauge: (language) ->
      languages = this.get('supportedLanguages')
      for item in languages
        if item.language is language
          this.set(
            fromLanguage: item
          )
          return

    getDisplayLangauge: (language) ->
      languages = this.get('supportedLanguages')
      for item in languages
        if item.language is language
          return item.display
  )

  return SettingsModel
