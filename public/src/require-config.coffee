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
    'jquery.ui.effect': '/bower_components/jquery-ui/ui/jquery.ui.effect'
    swfobject: '/bower_components/swfobject/swfobject/swfobject'
    underscore: '/bower_components/underscore/underscore'
    handlebars: '/bower_components/handlebars/handlebars'
    templates: 'lib/templates'
    purl: 'bower_components/purl/purl'
    'home.model': 'lib/home/home-model'
    'home.view': 'lib/home/home-view'
    'header.view': 'lib/header/header-view'
    'header.model': 'lib/header/header-model'
    'footer.view': 'lib/footer/footer-view'
    'login.view': 'lib/login/login-view'
    'signup.view': 'lib/signup/signup-view'
    'media.item.view': 'lib/media-item/media-item-view'
    'media.item.list.view': '/lib/media-item-list/media-item-list-view'
    'media.item.list.model': '/lib/media-item-list/media-item-list-model'
    'settings': '/lib/settings'
    'songs.data.provider':
      '/lib/songs-data-provider'
    'pagination.view': '/lib/pagination/pagination-view'
    'vocabulary.view': 'lib/vocabulary/vocabulary-view'
    'vocabulary.model': 'lib/vocabulary/vocabulary-model'
    #media
    'subtitles.scroller.view': '/lib/media/subtitles-scroller/subtitles-scroller-view'
    'subtitles.scroller.model': '/lib/media/subtitles-scroller/subtitles-scroller-model'
    'subtitles.player.model': '/lib/media/subtitles-player/subtitles-player-model'
    'subtitles.player.view': '/lib/media/subtitles-player/subtitles-player-view'
    'subtitles.controls.view': '/lib/media/subtitles-controls/subtitles-controls-view'
    'youtube.main.model': '/lib/media/youtube/youtube-main/youtube-main-model'
    'youtube.main.view': '/lib/media/youtube/youtube-main/youtube-main-view'
    'youtube.player.model': '/lib/media/youtube/youtube-player/youtube-player-model'
    'youtube.player.view': '/lib/media/youtube/youtube-player/youtube-player-view'
    'youtube.sync.model': '/lib/media/youtube/youtube-sync/youtube-sync-model'
    'youtube.sync.view': '/lib/media/youtube/youtube-sync/youtube-sync-view'
    'youtube.sync.subtitles.view': '/lib/media/youtube/youtube-sync/youtube-sync-subtitles-view'
    'create.song.view': 'lib/media/create-song/create-song-view'
    'create.song.model': 'lib/media/create-song/create-song-model'
    'edit.song.view': 'lib/media/edit-song/edit-song-view'
    'edit.song.model': 'lib/media/edit-song/edit-song-model'
    'add.song.view': '/lib/media/add-song/add-song-view'
    'add.song.model': '/lib/media/add-song/add-song-model'
    #vocab metrics
    'vocabulary.list.view': 'lib/vocabulary-metrics/vocabulary-list/vocabulary-list-view'
    'vocabulary.list.model': 'lib/vocabulary-metrics/vocabulary-list/vocabulary-list-model'
    'vocabulary.metrics.view': 'lib/vocabulary-metrics/vocabulary-metrics/vocabulary-metrics-view'
    'vocabulary.metrics.model': 'lib/vocabulary-metrics/vocabulary-metrics/vocabulary-metrics-model'
    #voggles
    'dictionary.view': 'lib/voggles/dictionary/dictionary-view'
    'dictionary.model': 'lib/voggles/dictionary/dictionary-model'
    #curation
    'edit.songs.view': 'lib/curation/edit-songs/edit-songs-view'
    'edit.songs.model': 'lib/curation/edit-songs/edit-songs-model'
    'create.classroom.view': 'lib/curation/create-classroom/create-classroom-view'
    'create.classroom.model': 'lib/curation/create-classroom/create-classroom-model'
    'edit.classroom.view': 'lib/curation/edit-classroom/edit-classroom-view'
    'edit.classroom.model': 'lib/curation/edit-classroom/edit-classroom-model'
    'classroom.view': 'lib/curation/classroom/classroom-view'
    'classroom.model': 'lib/curation/classroom/classroom-model'
    'classrooms.view': 'lib/curation/classrooms/classrooms-view'
    'classrooms.model': 'lib/curation/classrooms/classrooms-model'
    'classroom.preview.view': 'lib/curation/classroom-preview/classroom-preview-view'
    'classroom.preview.model': 'lib/curation/classroom-preview/classroom-preview-model'
      #vocab study
    'vocabulary.slider.view': 'lib/vocabulary-study/vocabulary-slider/vocabulary-slider-view'
    'vocabulary.slider.model': 'lib/vocabulary-study/vocabulary-slider/vocabulary-slider-model'
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
    'jquery.ui.effect':
      deps: [ 'jquery' ]
      exports: '$'
    handlebars:
      exports: 'Handlebars'
    swfobject:
      exports: 'swfobject'
)