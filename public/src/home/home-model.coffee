define [
  'dictionary.model',
  'backbone'
], (DictionaryModel, Backbone) ->
  HomeModel = Backbone.Model.extend(

    initialize: () ->
      this.dictionaryModel = new DictionaryModel(
        fromLanguage: this.get('settings').get('fromLanguage')
        toLanguage: this.get('settings').get('toLanguage')
      )

    lookup: (query) ->
      this.dictionaryModel.set(
        query: query
      )
  )

  return HomeModel