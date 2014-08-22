define [
  'backbone'
], (Backbone) ->
  CreateSongModel = Backbone.Model.extend(

    saveSong: (song, success) ->
      $.ajax(
        type: 'POST'
        url: '/api/songs/'
        dataType: 'json'
        data: song
        success: (data, result) =>
          if result is 'success'
            console.log('Success!')
            if success?
              success(data[0])
          else
            console.log('Error: ' + err)
        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return CreateSongModel