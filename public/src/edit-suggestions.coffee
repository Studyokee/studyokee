require [
  'studyokee.translation.data.provider',
  'edit.suggestions.model',
  'edit.suggestions.view'
], (StudyokeeTranslationDataProvider, EditSuggestionsModel, EditSuggestionsView) ->

  dataProvider = new StudyokeeTranslationDataProvider()

  dataElement = $('#data-dom')
  fromLanguage = dataElement.attr('data-fromLanguage')
  toLanguage = dataElement.attr('data-toLanguage')

  model = new EditSuggestionsModel(
    fromLanguage: fromLanguage
    toLanguage: toLanguage
    dataProvider: dataProvider
  )
  view = new EditSuggestionsView(
    model: model
  )
  $('.skee').html(view.render().el)