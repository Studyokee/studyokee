requirejs.config(
  enforceDefine: true
  baseUrl: '/'
  paths:
    backbone: '/bower_components/backbone/backbone'
    jquery: '/bower_components/jquery/jquery'
    jrdio: '/bower_components/jquery.rdio/jquery.rdio'
    swfobject: '/bower_components/swfobject/swfobject/swfobject'
    underscore: '/bower_components/underscore/underscore'
    handlebars: '/bower_components/handlebars/handlebars'
    templates: 'lib/templates'
    'home.model': 'lib/home/home-model'
    'home.view': 'lib/home/home-view'
    'header.view': 'lib/header/header-view'
    'media.item.view': 'lib/media-item/media-item-view'
    'media.item.list.view': '/lib/media-item-list/media-item-list-view'
    'settings': '/lib/settings'
    'add.song.view': '/lib/add-song/add-song-view'
    'add.song.model': '/lib/add-song/add-song-model'
    'language.settings.view': '/lib/language-settings/language-settings-view'
    'language.settings.model': '/lib/language-settings/language-settings-model'
    'subtitles.scroller.view': '/lib/subtitles-scroller/subtitles-scroller-view'
    'subtitles.player.model': '/lib/subtitles-player/subtitles-player-model'
    'subtitles.player.view': '/lib/subtitles-player/subtitles-player-view'
    'subtitles.upload.view': '/lib/subtitles-upload/subtitles-upload/subtitles-upload-view'
    'subtitles.upload.model': '/lib/subtitles-upload/subtitles-upload/subtitles-upload-model'
    'subtitles.sync.view': '/lib/subtitles-upload/subtitles-sync/subtitles-sync-view'
    'subtitles.controls.view': '/lib/subtitles-controls/subtitles-controls-view'
    'songs.data.provider':
      '/lib/songs-data-provider'
    'youtube.suggestions.data.provider':
      '/lib/youtube-suggestions-data-provider'
    'rdio.suggestions.data.provider':
      '/lib/rdio-suggestions-data-provider'
    'suggestions.model': '/lib/suggestions/suggestions-model'
    'suggestions.view': 'lib/suggestions/suggestions-view'
    'dictionary.view': 'lib/dictionary/dictionary-view'
    'dictionary.model': 'lib/dictionary/dictionary-model'
    'edit.suggestions.model': 'lib/edit-suggestions/edit-suggestions-model'
    'edit.suggestions.view': 'lib/edit-suggestions/edit-suggestions-view'
    'edit.songs.view': 'lib/edit-songs/edit-songs-view'
    'edit.songs.model': 'lib/edit-songs/edit-songs-model'
    'edit.song.view': 'lib/edit-song/edit-song-view'
    'edit.song.model': 'lib/edit-song/edit-song-model'
    'rdio.main.model': '/lib/rdio/rdio-main/rdio-main-model'
    'rdio.main.view': '/lib/rdio/rdio-main/rdio-main-view'
    'rdio.player.model': '/lib/rdio/rdio-player/rdio-player-model'
    'rdio.player.view': '/lib/rdio/rdio-player/rdio-player-view'
    'rdio.music.search': '/lib/rdio/rdio-player/rdio-search'
    'youtube.main.model': '/lib/youtube/youtube-main/youtube-main-model'
    'youtube.main.view': '/lib/youtube/youtube-main/youtube-main-view'
    'youtube.player.model': '/lib/youtube/youtube-player/youtube-player-model'
    'youtube.player.view': '/lib/youtube/youtube-player/youtube-player-view'
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
    swfobject:
      exports: 'swfobject'
)