define [
  'backbone'
], (Backbone) ->
  CreateSongModel = Backbone.Model.extend(

    saveSong: (trackName, artist, language, success) ->
      classroom =
        trackName: trackName
        artist: artist
        language: language
      $.ajax(
        type: 'POST'
        url: '/api/songs/'
        dataType: 'json'
        data: classroom
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