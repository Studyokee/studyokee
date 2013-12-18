define [
  'backbone'
], (Backbone) ->
  SettingsModel = Backbone.Model.extend(
    defaults:
      enableEdit: true
      enableLogging: true
      defaultToLanguage: 'en'
      defaultFromLanguage: 'es'
  )

  return SettingsModel
