define () ->
  class YoutubeTranslationDataProvider

    constructor: () ->

    getSegments: (rdioKey, language, callback) ->
      subtitles = []
      original = []
      for i in [0..10]
        subtitles.push(
          text: 'test'
          ts: 0
        )
        original.push('test')
      song =
        original: subtitles
        translation: original
      callback(song)

  return YoutubeTranslationDataProvider