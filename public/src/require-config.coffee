requirejs.config(
  enforceDefine: true
  paths:
    backbone: '/bower_components/backbone/backbone'
    jquery: '/bower_components/jquery/jquery'
    jrdio: '/bower_components/jquery.rdio/jquery.rdio'
    underscore: '/bower_components/underscore/underscore'
    handlebars: '/bower_components/handlebars/handlebars'
    'main.model': '/lib/main/main-model'
    'main.view': '/lib/main/main-view'
    'settings': '/lib/settings'
    'add.song.view': '/lib/add-song/add-song-view'
    'add.song.model': '/lib/add-song/add-song-model'
    'autocomplete.view': '/lib/autocomplete/autocomplete-view'
    'language.settings.view': '/lib/language-settings/language-settings-view'
    'language.settings.model': '/lib/language-settings/language-settings-model'
    'subtitles.scroller.view': '/lib/subtitles-scroller/subtitles-scroller-view'
    'subtitles.player.model': '/lib/subtitles-player/subtitles-player-model'
    'subtitles.player.view': '/lib/subtitles-player/subtitles-player-view'
    'subtitles.upload.view': '/lib/subtitles-upload/subtitles-upload/subtitles-upload-view'
    'subtitles.upload.model': '/lib/subtitles-upload/subtitles-upload/subtitles-upload-model'
    'subtitles.insert.text.view': '/lib/subtitles-upload/subtitles-insert-text/subtitles-insert-text-view'
    'subtitles.sync.view': '/lib/subtitles-upload/subtitles-sync/subtitles-sync-view'
    'subtitles.controls.view': '/lib/subtitles-controls/subtitles-controls-view'
    'music.player': '/lib/rdio-player'
    'test.translation.data.provider': '/lib/test-translation-data-provider'
    'tune.wiki.translation.data.provider':
      '/lib/tune-wiki-translation-data-provider'
    'studyokee.translation.data.provider':
      '/lib/studyokee-translation-data-provider'
    'suggestions.model': '/lib/suggestions/suggestions-model'
    'suggestions.view': 'lib/suggestions/suggestions-view'
    'yabla.dictionary.data.provider': '/lib/yabla-dictionary-data-provider'
    templates: '/lib/templates'
  shim:
    backbone:
      deps: [ 'underscore', 'jquery' ]
      exports: 'Backbone'
    underscore:
      exports: '_'
    jrdio:
      deps: [ 'jquery' ]
      exports: '$'
    handlebars:
      exports: 'Handlebars'
)