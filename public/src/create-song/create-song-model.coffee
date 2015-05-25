define [
  'backbone'
], (Backbone) ->
  CreateSongModel = Backbone.Model.extend(

    saveSong: (fields, success) ->
      fields.language = this.get('defaultLanguage')
      $.ajax(
        type: 'POST'
        url: '/api/songs/'
        dataType: 'json'
        data: fields
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