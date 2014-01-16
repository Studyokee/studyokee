define [
  'backbone'
], (Backbone) ->

  SubtitlesUploadModel = Backbone.Model.extend(
    defaults:
      subtitles:
        original: []
        translation: []

    initialize: () ->
      dataProvider = this.get('dataProvider')
      id = this.get('id')
      toLanguage = this.get('toLanguage')
      
      dataProvider.getSegments(id, toLanguage, (subtitles) =>
        if subtitles?
          this.set(
            subtitles: subtitles
          )
      )
      
    saveTranslation: (translation, callback) ->
      id = this.get('id')
      toLanguage = this.get('toLanguage')

      this.get('dataProvider').saveTranslation(id, toLanguage, translation, () =>
        callback()
        subtitles = this.get('subtitles')
        updatedSubtitles =
          original: subtitles.original
          translation: translation
        this.set(
          subtitles: updatedSubtitles
        )
      )

    saveSubtitles: (original, callback) ->
      id = this.get('id')
      this.get('dataProvider').saveSubtitles(id, original, () =>
        callback()
        subtitles = this.get('subtitles')
        updatedSubtitles =
          original: original
          translation: subtitles.translation
        this.set(
          subtitles: updatedSubtitles
        )
      )
  )

  return SubtitlesUploadModel