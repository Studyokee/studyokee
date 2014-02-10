define [
  'suggestions.model',
  'backbone'
], (SuggestionsModel, Backbone) ->

  EditSuggestionsModel = Backbone.Model.extend(
    initialize: () ->
      this.suggestionsModel = new SuggestionsModel(
        dataProvider: this.get('dataProvider')
        toLanguage: this.get('toLanguage')
        fromLanguage: this.get('fromLanguage')
        settings: this.get('settings')
      )

    addSong: (id) ->
      if not id? or id.length is 0
        return

      songs = this.suggestionsModel.get('data') || []
      ids = []
      for song in songs
        if not song?.song?._id
          continue
        if song.song._id is id
          return
        ids.push(song.song._id)

      ids.push(id)
      callback = () =>
        this.suggestionsModel.updateSuggestions()
      this.get('dataProvider').saveSuggestions(this.get('fromLanguage'), this.get('toLanguage'), ids, callback)
  )

  return EditSuggestionsModel