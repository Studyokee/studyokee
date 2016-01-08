define [
  'backbone'
], (Backbone) ->
  SubtitlesScrollerModel = Backbone.Model.extend(
    default:
      processedLines: []
      i: 0
      isLoading: true

    initialize: () ->
      this.on('change:processedLines', () =>
        console.log('scroller processedLines changed')
        this.trigger('highlightUpdate')
      )
  )

  return SubtitlesScrollerModel