define [
  'backbone',
  'youtube.main.model',
  'underscore',
  'jquery'
], (Backbone, SyncModel, _, $) ->
  EditSongModel = Backbone.Model.extend(

    initialize: () ->
      this.syncModel = new SyncModel(
        language: 'en'
        editMode: true
      )

      this.getSong()

    getSong: () ->
      $.ajax(
        type: 'GET'
        url: '/api/songs/' + this.get('id')
        dataType: 'json'
        success: (song) =>
          this.set(
            data: song
          )
          this.trigger('change')
          this.syncModel.trigger('changeSong', song)
        error: (err) =>
          console.log('Error: ' + err)
      )

    saveSubtitles: (subtitlesText, success) ->
      lines = subtitlesText.split('\n')
      subtitles = []
      ts = 0
      for line in lines
        subtitle =
          text: line
          ts: ts
        subtitles.push(subtitle)
        ts += 1500

      song = this.get('data')
      song.subtitles = subtitles
      this.saveSong(song, success)

    saveSync: (success) ->
      song = this.get('data')
      subtitles = song.subtitles
      for i in [0..subtitles.length]
        currentLine = subtitles[i]
        nextLine = subtitles[i+1]
        if nextLine? and currentLine.ts > nextLine.ts
          subtitles[i+1].ts = currentLine.ts + 1500
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
