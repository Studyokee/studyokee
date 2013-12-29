define [
  'backbone'
], (Backbone) ->
  AddSongModel = Backbone.Model.extend(
    defaults:
      showAC: false

    search: (query) ->
      musicPlayer = this.get('musicPlayer')
      this.set(
        songs: []
        isLoading: true
        showAC: true
      )

      musicPlayer.search(query, (suggestions) =>
        this.set(
          songs: suggestions
          isLoading: false
        )
      )

  )

  return AddSongModel