define [
  'backbone'
], (Backbone) ->
  EditSongsModel = Backbone.Model.extend(

    initialize: () ->
      this.getSongs()

    getSongs: () ->
      $.ajax(
        type: 'GET'
        url: '/api/songs'
        dataType: 'json'
        success: (res) =>
          this.set(
            data: res
          )
        error: (err) =>
          console.log('Error: ' + err)
      )

    deleteSong: (song) ->
      $.ajax(
        type: 'DELETE'
        url: '/api/songs/' + song._id
        success: (res) =>
          console.log('Success: ' + JSON.stringify(res, null, 4))
          this.getSongs()
        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return EditSongsModel

  