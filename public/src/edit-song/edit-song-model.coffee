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
          this.set(
            data: res
          )
          this.trigger('change')
        error: (err) =>
          console.log('Error: ' + err)
      )

    saveSubtitles: (subtitlesText, success) ->
      lines = subtitlesText.split('\n')
      subtitles = []
      for line in lines
        subtitle =
          text: line
          ts: 0
        subtitles.push(subtitle)

      song = this.get('data')
      song.subtitles = subtitles
      this.saveSong(song, success)

    saveTranslation: (translationText, success) ->
      translation = translationText.split('\n')
      song = this.get('data')
      if song.translations?.length > 0
        song.translations[0].data = translation
      else
        firstTranslation =
          language: 'en'
          data: translation
        song.translations = [firstTranslation]
      this.saveSong(song, success)

    saveSong: (song, success) ->
      $.ajax(
        type: 'PUT'
        url: '/api/songs/' + this.get('id')
        data:
          song: song
        success: (res) =>
          this.getSong()
          success?()
        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return EditSongModel
