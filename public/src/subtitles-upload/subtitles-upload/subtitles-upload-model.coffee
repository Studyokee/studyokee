define [
  'backbone'
], (Backbone) ->

  SubtitlesUploadModel = Backbone.Model.extend(
    # defaults:
    #   subtitles:
    #     original: []
    #     translation: []

    initialize: () ->
      # id = this.get('id')
      
    # saveTranslation: (translation, callback) ->
    #   id = this.get('id')
    #   toLanguage = this.get('toLanguage')

    #   this.get('dataProvider').saveTranslation(id, toLanguage, translation, () =>
    #     callback()
    #     subtitles = this.get('subtitles')
    #     updatedSubtitles =
    #       original: subtitles.original
    #       translation: translation
    #     this.set(
    #       subtitles: updatedSubtitles
    #     )
    #   )

    # saveSubtitles: (original, callback) ->
    #   id = this.get('id')
    #   this.get('dataProvider').saveSubtitles(id, original, () =>
    #     callback()
    #     subtitles = this.get('subtitles')
    #     updatedSubtitles =
    #       original: original
    #       translation: subtitles.translation
    #     this.set(
    #       subtitles: updatedSubtitles
    #     )
    #   )
  )

  return SubtitlesUploadModel