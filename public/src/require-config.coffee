requirejs.config(
  enforceDefine: true
  baseUrl: '/'
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
    'song.list.view': '/lib/song-list/song-list-view'
    'language.settings.view': '/lib/language-settings/language-settings-view'
    'language.settings.model': '/lib/language-settings/language-settings-model'
    'subtitles.scroller.view': '/lib/subtitles-scroller/subtitles-scroller-view'
    'subtitles.player.model': '/lib/subtitles-player/subtitles-player-model'
    'subtitles.player.view': '/lib/subtitles-player/subtitles-player-view'
    'subtitles.upload.view': '/lib/subtitles-upload/subtitles-upload/subtitles-upload-view'
    'subtitles.upload.model': '/lib/subtitles-upload/subtitles-upload/subtitles-upload-model'
    'subtitles.insert.text.view': '/lib/subtitles-upload/subtitles-insert-text/subtitles-insert-text-view'
    'edit.subtitles.view': '/lib/subtitles-upload/edit-subtitles/edit-subtitles-view'
    'subtitles.sync.view': '/lib/subtitles-upload/subtitles-sync/subtitles-sync-view'
    'subtitles.controls.view': '/lib/subtitles-controls/subtitles-controls-view'
    'music.player': '/lib/music-player/rdio/rdio-player'
    'music.search': '/lib/music-player/rdio/rdio-search'
    'test.translation.data.provider': '/lib/test-translation-data-provider'
    'tune.wiki.translation.data.provider':
      '/lib/tune-wiki-translation-data-provider'
    'studyokee.translation.data.provider':
      '/lib/studyokee-translation-data-provider'
    'suggestions.model': '/lib/suggestions/suggestions-model'
    'suggestions.view': 'lib/suggestions/suggestions-view'
    'dictionary.view': 'lib/dictionary/dictionary-view'
    'dictionary.model': 'lib/dictionary/dictionary-model'
    'edit.suggestions.model': 'lib/edit-suggestions/edit-suggestions-model'
    'edit.suggestions.view': 'lib/edit-suggestions/edit-suggestions-view'
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