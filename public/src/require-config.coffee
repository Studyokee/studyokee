requirejs.config(
  enforceDefine: true
  baseUrl: '/'
  paths:
    backbone: '/bower_components/backbone/backbone'
    jquery: '/bower_components/jquery/jquery'
    bootstrap: '/bower_components/bootstrap/dist/js/bootstrap'
    'jquery.ui.core': '/bower_components/jquery-ui/ui/jquery.ui.core'
    'jquery.ui.mouse': '/bower_components/jquery-ui/ui/jquery.ui.mouse'
    'jquery.ui.widget': '/bower_components/jquery-ui/ui/jquery.ui.widget'
    'jquery.ui.sortable': '/bower_components/jquery-ui/ui/jquery.ui.sortable'
    swfobject: '/bower_components/swfobject/swfobject/swfobject'
    underscore: '/bower_components/underscore/underscore'
    handlebars: '/bower_components/handlebars/handlebars'
    templates: 'lib/templates'
    purl: 'bower_components/purl/purl'
    'home.model': 'lib/home/home-model'
    'home.view': 'lib/home/home-view'
    'header.view': 'lib/header/header-view'
    'footer.view': 'lib/footer/footer-view'
    'login.view': 'lib/login/login-view'
    'media.item.view': 'lib/media-item/media-item-view'
    'media.item.list.view': '/lib/media-item-list/media-item-list-view'
    'media.item.list.model': '/lib/media-item-list/media-item-list-model'
    'settings': '/lib/settings'
    'add.song.view': '/lib/add-song/add-song-view'
    'add.song.model': '/lib/add-song/add-song-model'
    'subtitles.scroller.view': '/lib/subtitles-scroller/subtitles-scroller-view'
    'subtitles.scroller.model': '/lib/subtitles-scroller/subtitles-scroller-model'
    'subtitles.player.model': '/lib/subtitles-player/subtitles-player-model'
    'subtitles.player.view': '/lib/subtitles-player/subtitles-player-view'
    'subtitles.controls.view': '/lib/subtitles-controls/subtitles-controls-view'
    'songs.data.provider':
      '/lib/songs-data-provider'
    'suggestions.model': '/lib/suggestions/suggestions-model'
    'suggestions.view': 'lib/suggestions/suggestions-view'
    'dictionary.view': 'lib/dictionary/dictionary-view'
    'dictionary.model': 'lib/dictionary/dictionary-model'
    'vocabulary.view': 'lib/vocabulary/vocabulary-view'
    'vocabulary.model': 'lib/vocabulary/vocabulary-model'
    'edit.songs.view': 'lib/edit-songs/edit-songs-view'
    'edit.songs.model': 'lib/edit-songs/edit-songs-model'
    'create.song.view': 'lib/create-song/create-song-view'
    'create.song.model': 'lib/create-song/create-song-model'
    'edit.song.view': 'lib/edit-song/edit-song-view'
    'edit.song.model': 'lib/edit-song/edit-song-model'
    'create.classroom.view': 'lib/create-classroom/create-classroom-view'
    'create.classroom.model': 'lib/create-classroom/create-classroom-model'
    'edit.classroom.view': 'lib/edit-classroom/edit-classroom-view'
    'edit.classroom.model': 'lib/edit-classroom/edit-classroom-model'
    'classroom.view': 'lib/classroom/classroom-view'
    'classroom.model': 'lib/classroom/classroom-model'
    'classrooms.view': 'lib/classrooms/classrooms-view'
    'classrooms.model': 'lib/classrooms/classrooms-model'
    'classroom.preview.view': 'lib/classroom-preview/classroom-preview-view'
    'classroom.preview.model': 'lib/classroom-preview/classroom-preview-model'
    'youtube.main.model': '/lib/youtube/youtube-main/youtube-main-model'
    'youtube.main.view': '/lib/youtube/youtube-main/youtube-main-view'
    'youtube.player.model': '/lib/youtube/youtube-player/youtube-player-model'
    'youtube.player.view': '/lib/youtube/youtube-player/youtube-player-view'
    'youtube.sync.model': '/lib/youtube/youtube-sync/youtube-sync-model'
    'youtube.sync.view': '/lib/youtube/youtube-sync/youtube-sync-view'
    'youtube.sync.subtitles.view': '/lib/youtube/youtube-sync/youtube-sync-subtitles-view'
    'pagination.view': '/lib/pagination/pagination-view'
  shim:
    backbone:
      deps: [ 'underscore', 'jquery' ]
      exports: 'Backbone'
    underscore:
      exports: '_'
    bootstrap:
      deps: [ 'jquery' ]
      exports: '$'
    purl:
      deps: [ 'jquery' ]
      exports: '$'
    'jquery.ui.core':
      deps: [ 'jquery' ]
      exports: '$'
    'jquery.ui.mouse':
      deps: [ 'jquery', 'jquery.ui.widget' ]
      exports: '$'
    'jquery.ui.widget':
      deps: [ 'jquery' ]
      exports: '$'
    'jquery.ui.sortable':
      deps: [ 'jquery', 'jquery.ui.core', 'jquery.ui.mouse', 'jquery.ui.widget' ]
      exports: '$'
    handlebars:
      exports: 'Handlebars'
    swfobject:
      exports: 'swfobject'
)