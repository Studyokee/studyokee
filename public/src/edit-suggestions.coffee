require [
  'youtube.suggestions.data.provider',
  'edit.suggestions.model',
  'edit.suggestions.view'
], (SuggestionsDataProvider, EditSuggestionsModel, EditSuggestionsView) ->

  dataElement = $('#data-dom')
  fromLanguage = dataElement.attr('data-fromLanguage')
  toLanguage = dataElement.attr('data-toLanguage')

  model = new EditSuggestionsModel(
    fromLanguage: fromLanguage
    toLanguage: toLanguage
    dataProvider: new SuggestionsDataProvider()
  )
  view = new EditSuggestionsView(
    model: model
  )
  $('.skee').html(view.render().el)