define [
  'backbone',
  'underscore',
  'jquery'
], (Backbone, _, $) ->
  EditSongModel = Backbone.Model.extend(

    initialize: () ->
      this.getSong()

    getSong: () ->
      $.ajax(
        type: 'GET'
        url: '/api/songs/' + this.get('id')
        dataType: 'json'
        success: (res) =>
          if res? and not res.metadata?.artist?
            this.fetchRdioData(res)
          else
            this.set(
              data: res
            )
        error: (err) =>
          console.log('Error: ' + err)
      )

    saveSong: (song, success) ->
      $.ajax(
        type: 'PUT'
        url: '/api/songs/' + this.get('id')
        data:
          song: song
        success: (res) =>
          console.log('Success!')
          success()
        error: (err) =>
          console.log('Error: ' + err)
      )

    fetchRdioData: (data) ->
      $.ajax(
        type: 'GET'
        url: '/api/rdio/data/' + data.rdioKey
        dataType: 'json'
        success: (res) =>
          if not data.metadata?
            data.metadata = {}

          data.metadata.artist = res.artist
          data.metadata.trackName = res.name
          this.set(
            data: data
          )
        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return EditSongModel
