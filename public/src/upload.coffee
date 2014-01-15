require [
  'settings',
  'music.player',
  'studyokee.translation.data.provider',
  'subtitles.upload.model',
  'subtitles.upload.view'
], (Settings, MusicPlayer, StudyokeeTranslationDataProvider, SubtitlesUploadModel, SubtitlesUploadView) ->

  settings = new Settings()
  musicPlayer = new MusicPlayer()
  dataProvider = new StudyokeeTranslationDataProvider()

  dataElement = $('#data-dom')
  rdioKey = dataElement.attr('data-rdioKey')
  toLanguage = dataElement.attr('data-toLanguage')

  model = new SubtitlesUploadModel(
    settings: settings
    id: rdioKey
    toLanguage: toLanguage
    musicPlayer: musicPlayer
    dataProvider: dataProvider
  )
  view = new SubtitlesUploadView(
    model: model
  )
  $('.skee').html(view.render().el)