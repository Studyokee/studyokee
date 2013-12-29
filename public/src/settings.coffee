define [
  'backbone'
], (Backbone) ->
  SettingsModel = Backbone.Model.extend(
    defaults:
      enableEdit: true
      enableLogging: true
      loadStartTime: 0
      defaultToLanguage: 'en'
      defaultFromLanguage: 'es'
  )

  return SettingsModel
