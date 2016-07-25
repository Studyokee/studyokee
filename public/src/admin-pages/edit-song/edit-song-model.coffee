define [
  'backbone',
  'youtube.sync.model',
  'underscore',
  'jquery'
], (Backbone, SyncModel, _, $) ->
  EditSongModel = Backbone.Model.extend(

    initialize: () ->
      this.syncModel = new SyncModel()

      this.getSong()
      this.getDictionary()

    getSong: () ->
      $.ajax(
        type: 'GET'
        url: '/api/songs/' + this.get('id')
        dataType: 'json'
        success: (song) =>
          resolutions = {}
          if song?.resolutions?
            resolutionsArray = song?.resolutions
            for resolution in resolutionsArray
              resolutions[resolution.word] = resolution.resolution
          console.log(JSON.stringify(resolutions, null, 4))
          
          this.set(
            data: song
            resolutions: resolutions
          )
          this.trigger('change')
          this.syncModel.set(
            currentSong: song
          )
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
      song = this.syncModel.get('currentSong')
      subtitles = song.subtitles
      this.saveSong(song, success)

    saveTranslation: (translationText, success) ->
      translation = translationText.split('\n')
      song = this.get('data')
      if song.translations?.length > 0
        song.translations[0].data = translation
      else
        firstTranslation =
          language: this.get('settings').get('toLanguage').language
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

    getDictionary: () ->
      fromLanguage = this.get('settings').get('fromLanguage').language
      toLanguage = this.get('settings').get('toLanguage').language
      $.ajax(
        type: 'GET'
        url: '/api/dictionary/' + fromLanguage + '/' + toLanguage + '/index'
        dataType: 'json'
        success: (words) =>
          if words?
            dictionary = {}
            stems = {}
            for dictWord in words
              dictionary[dictWord.word] = 1
              stems[dictWord.stem] = 1

            this.set(
              dictionary: dictionary
              stems: stems
            )
            this.trigger('change')
        error: (err) =>
          console.log('Error: ' + err)
      )

    addResolution: (word, resolution) ->
      $.ajax(
        type: 'PUT'
        url: '/api/songs/' + this.get('id') + '/resolutions/'
        data:
          word: word
          resolution: resolution
        success: (res) =>
          console.log('Added resolution ' + resolution + ' for ' + word)
          resolutions = this.get('resolutions')
          resolutions[word.toLowerCase()] = resolution
          this.set(
            resolutions: resolutions
          )
          this.trigger('change')
        error: (err) =>
          console.log('Error: ' + err)
      )

    addToDictionary: (raw) ->
      rawParts = raw.split('\n')
      words = []
      for rawPart in rawParts
        subParts = rawPart.split('=')

        if subParts.length is 5
          word = {}
          word.rank = $.trim(subParts[0])
          word.word = $.trim(subParts[1]).toLowerCase()
          word.part = $.trim(subParts[2])
          word.stem = word.word
          endings = ['a','o','as','os','es']
          str = word.word
          if (str.length > 2 and (word.part is 'adj' or word.part is 'nm' or word.part is 'nf'))
            for suffix in endings
              start = str.indexOf(suffix, str.length - suffix.length)
              if start isnt -1
                # has stem ending, strip down to stem and use that
                word.stem = str.substr(0, start)
          
          word.def = $.trim(subParts[3])
          word.example = $.trim(subParts[4])
          word.fromLanguage = 'es'
          word.toLanguage = 'en'
          words.push(word)
        else
          console.log('subparts: ' + JSON.stringify(subParts, null, 4))
          console.log('words.length: ' + words.length + ' vs: ' + (parseInt(subParts[0]) - 1))
          break

      if words.length > 0
        $.ajax(
          type: 'POST'
          url: '/api/dictionary/add'
          dataType: 'json'
          data:
            words: words
          success: (res) =>
            console.log('Added definition ' + JSON.stringify(words, null, 4))
            dictionary = this.get('dictionary')
            stems = this.get('stems')

            for word in words
              dictionary[word.word] = 1
              stems[word.stem] = 1
            this.set(
              dictionary: dictionary
              stems: stems
            )
            this.trigger('change')
          error: (err) =>
            console.log('Error: ' + err)
        )

  )

  return EditSongModel
