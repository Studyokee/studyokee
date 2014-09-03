define [
  'backbone'
], (Backbone) ->
  SettingsModel = Backbone.Model.extend(
    defaults:
      enableLogging: true
      defaultToLanguage: 'en'
      defaultFromLanguage: 'es'
      toLanguage: 'en'
      fromLanguage: 'es'
      userId: null
  )

  return SettingsModel
