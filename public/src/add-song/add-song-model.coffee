define [
  'backbone'
], (Backbone) ->
  AddSongModel = Backbone.Model.extend(
    defaults:
      showAC: false

    search: (query) ->
      musicPlayer = this.get('musicPlayer')

      musicPlayer.search(query, (results) =>
        this.set(
          suggestions: results
        )
      )

  )

  return AddSongModel