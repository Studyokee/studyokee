define [
  'backbone'
], (Backbone) ->
  SubtitlesScrollerModel = Backbone.Model.extend(
    default:
      subtitles: []
      translation: []
      i: 0
      isLoading: true
  )

  return SubtitlesScrollerModel