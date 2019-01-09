define [
  'backbone'
], (Backbone) ->
  toLanguages = [
    {'language': 'en', 'display': 'English'}
  ]
  fromLanguages = [
    {'language': 'es', 'display': 'Spanish'}
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
      for item in fromLanguages
        if item.language is language
          this.set(
            fromLanguage: item
          )
          return
  )

  return SettingsModel
