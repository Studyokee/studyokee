require [
  'youtube.suggestions.data.provider',
  'edit.suggestions.model',
  'edit.suggestions.view',
  'settings'
], (SuggestionsDataProvider, EditSuggestionsModel, EditSuggestionsView, Settings) ->

  dataElement = $('#data-dom')
  fromLanguage = dataElement.attr('data-fromLanguage')
  toLanguage = dataElement.attr('data-toLanguage')

  settings = new Settings()

  model = new EditSuggestionsModel(
    fromLanguage: fromLanguage
    toLanguage: toLanguage
    dataProvider: new SuggestionsDataProvider()
    settings: settings
  )
  view = new EditSuggestionsView(
    model: model
  )
  $('.skee').html(view.render().el)