define [
  'backbone',
  'music.search'
], (Backbone, MusicSearch) ->
  AddSongModel = Backbone.Model.extend(
    defaults:
      showAC: false

    initialize: () ->
      this.musicSearch = new MusicSearch()

    search: (query) ->
      this.set(
        songs: []
        isLoading: true
        showAC: true
      )

      this.musicSearch.search(query, (suggestions) =>
        this.set(
          songs: suggestions
          isLoading: false
        )
      )

  )

  return AddSongModel