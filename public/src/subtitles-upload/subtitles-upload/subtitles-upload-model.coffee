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

      # this.listenTo(this, 'change:subtitles', () =>
      #   this.updateChecks()
      # )

    # updateChecks: () ->
    #   subtitles = this.get('subtitles')

    #   hasOriginal = subtitles? and subtitles.original and subtitles.original.length > 0
    #   hasSync = hasOriginal and subtitles.original.length > 1 and subtitles.original[1].ts != 0
    #   hasTranslation = subtitles? and subtitles.translation and subtitles.translation.length > 0
      
    #   this.set(
    #     hasOriginal: hasOriginal
    #     hasSync: hasSync
    #     hasTranslation: hasTranslation
    #   )

    # saveOriginal: (originalSubtitles, callback) ->
    #   id = this.get('id')
    #   fromLanguage = this.get('fromLanguage')

    #   onSuccess = () =>
    #     subtitles = this.get('subtitles')
    #     subtitles.original = originalSubtitles
    #     this.trigger('change:subtitles')

    #     callback()

    #   dataProvider = this.get('dataProvider')
    #   dataProvider.createSong(id, fromLanguage, () =>
    #     dataProvider.saveSubtitles(id, originalSubtitles, onSuccess)
    #   )
      
    saveTranslation: (translation, callback) ->
      id = this.get('id')
      toLanguage = this.get('toLanguage')

      this.get('dataProvider').saveTranslation(id, toLanguage, translation, callback)

    # saveSync: (originalSubtitles, callback) ->
    #   id = this.get('id')
    #   fromLanguage = this.get('fromLanguage')

    #   onSuccess = () =>
    #     subtitles = this.get('subtitles')
    #     subtitles.original = originalSubtitles
    #     this.trigger('change:subtitles')

    #     callback()

    #   dataProvider = this.get('dataProvider')
    #   dataProvider.saveSubtitles(id, originalSubtitles, onSuccess)
  )

  return SubtitlesUploadModel