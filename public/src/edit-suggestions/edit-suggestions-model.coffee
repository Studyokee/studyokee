define [
  'add.song.model',
  'suggestions.model',
  'backbone'
], (AddSongModel, SuggestionsModel, Backbone) ->

  EditSuggestionsModel = Backbone.Model.extend(
    defaults:
      songs: []

    initialize: () ->
      this.addSongModel = new AddSongModel()
      this.suggestionsModel = new SuggestionsModel(
        dataProvider: this.get('dataProvider')
        toLanguage: this.get('toLanguage')
        fromLanguage: this.get('fromLanguage')
        enableLogging: true
      )

      this.addSongModel.on('select', (song) =>
        this.addSong(song)
      )

      this.listenTo(this.suggestionsModel, 'change:songs', () =>
        this.saveSuggestions()
      )

    addSong: (song) ->
      songs = this.suggestionsModel.get('songs') || []
      newSongs = [song]
      this.suggestionsModel.set(
        songs: newSongs.concat(songs)
      )

    removeSong: (toRemove) ->
      songs = this.suggestionsModel.get('songs')
      updatedList = []
      for song in songs
        if song.key isnt toRemove.key
          updatedList.push(song)

      this.suggestionsModel.set(
        songs: updatedList
      )

    saveSuggestions: () ->
      this.get('dataProvider').saveSuggestions(this.get('fromLanguage'), this.get('toLanguage'), this.suggestionsModel.get('songs'))

  )

  return EditSuggestionsModel