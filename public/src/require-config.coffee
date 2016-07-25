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



    #vocabulary-page
    'vocabulary.view': 'lib/vocabulary-page/vocabulary/vocabulary-view'
    'vocabulary.model': 'lib/vocabulary-page/vocabulary/vocabulary-model'
    'vocabulary.list.view': 'lib/vocabulary-page/vocabulary-list/vocabulary-list-view'
    'vocabulary.list.model': 'lib/vocabulary-page/vocabulary-list/vocabulary-list-model'
    'vocabulary.metrics.view': 'lib/vocabulary-page/vocabulary-metrics/vocabulary-metrics-view'
    'vocabulary.metrics.model': 'lib/vocabulary-page/vocabulary-metrics/vocabulary-metrics-model'
    'vocabulary.slider.view': 'lib/vocabulary-page/vocabulary-slider/vocabulary-slider-view'
    'vocabulary.slider.model': 'lib/vocabulary-page/vocabulary-slider/vocabulary-slider-model'

    #classroom-page
    'classroom.view': 'lib/classroom-page/classroom/classroom-view'
    'classroom.model': 'lib/classroom-page/classroom/classroom-model'
    'subtitles.scroller.view': '/lib/classroom-page/subtitles-scroller/subtitles-scroller-view'
    'subtitles.scroller.model': '/lib/classroom-page/subtitles-scroller/subtitles-scroller-model'
    'subtitles.controls.view': '/lib/classroom-page/subtitles-controls/subtitles-controls-view'
    'youtube.main.model': '/lib/classroom-page/youtube-main/youtube-main-model'
    'youtube.main.view': '/lib/classroom-page/youtube-main/youtube-main-view'
    'youtube.player.model': '/lib/classroom-page/youtube-player/youtube-player-model'
    'youtube.player.view': '/lib/classroom-page/youtube-player/youtube-player-view'
    'dictionary.view': 'lib/classroom-page/dictionary/dictionary-view'
    'dictionary.model': 'lib/classroom-page/dictionary/dictionary-model'

    #classrooms-page
    'classrooms.view': 'lib/classrooms-page/classrooms/classrooms-view'
    'classrooms.model': 'lib/classrooms-page/classrooms/classrooms-model'
    'classroom.preview.view': 'lib/classrooms-page/classroom-preview/classroom-preview-view'
    'classroom.preview.model': 'lib/classrooms-page/classroom-preview/classroom-preview-model'

    #admin-pages
    'youtube.sync.model': '/lib/admin-pages/youtube/youtube-sync/youtube-sync-model'
    'youtube.sync.view': '/lib/admin-pages/youtube/youtube-sync/youtube-sync-view'
    'youtube.sync.subtitles.view': '/lib/admin-pages/youtube/youtube-sync/youtube-sync-subtitles-view'
    'create.song.view': 'lib/admin-pages/create-song/create-song-view'
    'create.song.model': 'lib/admin-pages/create-song/create-song-model'
    'edit.song.view': 'lib/admin-pages/edit-song/edit-song-view'
    'edit.song.model': 'lib/admin-pages/edit-song/edit-song-model'
    'add.song.view': '/lib/admin-pages/add-song/add-song-view'
    'add.song.model': '/lib/admin-pages/add-song/add-song-model'
    'edit.songs.view': 'lib/admin-pages/edit-songs/edit-songs-view'
    'edit.songs.model': 'lib/admin-pages/edit-songs/edit-songs-model'
    'create.classroom.view': 'lib/admin-pages/create-classroom/create-classroom-view'
    'create.classroom.model': 'lib/admin-pages/create-classroom/create-classroom-model'
    'edit.classroom.view': 'lib/admin-pages/edit-classroom/edit-classroom-view'
    'edit.classroom.model': 'lib/admin-pages/edit-classroom/edit-classroom-model'
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