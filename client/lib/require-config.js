(function() {
  requirejs.config({
    enforceDefine: true,
    baseUrl: '/optimized',
    paths: {
      backbone: '../bower_components/backbone/backbone',
      jquery: '../bower_components/jquery/jquery.min',
      bootstrap: '../bower_components/bootstrap/dist/js/bootstrap.min',
      'jquery.ui.core': '../bower_components/jquery-ui/ui/minified/jquery.ui.core.min',
      'jquery.ui.mouse': '../bower_components/jquery-ui/ui/minified/jquery.ui.mouse.min',
      'jquery.ui.widget': '../bower_components/jquery-ui/ui/minified/jquery.ui.widget.min',
      'jquery.ui.sortable': '../bower_components/jquery-ui/ui/minified/jquery.ui.sortable.min',
      'jquery.ui.effect': '../bower_components/jquery-ui/ui/minified/jquery.ui.effect.min',
      underscore: '../bower_components/underscore/underscore-min',
      handlebars: '../bower_components/handlebars/handlebars.min',
      purl: '../bower_components/purl/purl',
      templates: 'templates',
      'home.model': 'home/home-model',
      'home.view': 'home/home-view',
      'header.view': 'header/header-view',
      'header.model': 'header/header-model',
      'footer.view': 'footer/footer-view',
      'login.view': 'login/login-view',
      'signup.view': 'signup/signup-view',
      'media.item.view': 'media-item/media-item-view',
      'media.item.list.view': 'media-item-list/media-item-list-view',
      'media.item.list.model': 'media-item-list/media-item-list-model',
      'settings': 'settings',
      'songs.data.provider': 'songs-data-provider',
      'pagination.view': 'pagination/pagination-view',
      'vocabulary.view': 'vocabulary-page/vocabulary/vocabulary-view',
      'vocabulary.model': 'vocabulary-page/vocabulary/vocabulary-model',
      'vocabulary.list.view': 'vocabulary-page/vocabulary-list/vocabulary-list-view',
      'vocabulary.metrics.view': 'vocabulary-page/vocabulary-metrics/vocabulary-metrics-view',
      'vocabulary.slider.view': 'vocabulary-page/vocabulary-slider/vocabulary-slider-view',
      'vocabulary.slider.model': 'vocabulary-page/vocabulary-slider/vocabulary-slider-model',
      'classroom.page': 'classroom-page/classroom-page',
      'classroom.view': 'classroom-page/classroom/classroom-view',
      'classroom.model': 'classroom-page/classroom/classroom-model',
      'subtitles.scroller.view': 'classroom-page/subtitles-scroller/subtitles-scroller-view',
      'subtitles.scroller.model': 'classroom-page/subtitles-scroller/subtitles-scroller-model',
      'subtitles.controls.view': 'classroom-page/subtitles-controls/subtitles-controls-view',
      'youtube.player.model': 'classroom-page/youtube-player/youtube-player-model',
      'youtube.player.view': 'classroom-page/youtube-player/youtube-player-view',
      'dictionary.view': 'classroom-page/dictionary/dictionary-view',
      'dictionary.model': 'classroom-page/dictionary/dictionary-model',
      'classrooms.view': 'classrooms-page/classrooms/classrooms-view',
      'classrooms.model': 'classrooms-page/classrooms/classrooms-model',
      'classroom.preview.view': 'classrooms-page/classroom-preview/classroom-preview-view',
      'classroom.preview.model': 'classrooms-page/classroom-preview/classroom-preview-model',
      'youtube.sync.model': 'admin-pages/youtube-sync/youtube-sync-model',
      'youtube.sync.view': 'admin-pages/youtube-sync/youtube-sync-view',
      'youtube.sync.subtitles.view': 'admin-pages/youtube-sync/youtube-sync-subtitles-view',
      'create.song.view': 'admin-pages/create-song/create-song-view',
      'create.song.model': 'admin-pages/create-song/create-song-model',
      'edit.song.view': 'admin-pages/edit-song/edit-song-view',
      'edit.song.model': 'admin-pages/edit-song/edit-song-model',
      'add.song.view': 'admin-pages/add-song/add-song-view',
      'add.song.model': 'admin-pages/add-song/add-song-model',
      'edit.songs.view': 'admin-pages/edit-songs/edit-songs-view',
      'edit.songs.model': 'admin-pages/edit-songs/edit-songs-model',
      'create.classroom.view': 'admin-pages/create-classroom/create-classroom-view',
      'create.classroom.model': 'admin-pages/create-classroom/create-classroom-model',
      'edit.classroom.view': 'admin-pages/edit-classroom/edit-classroom-view',
      'edit.classroom.model': 'admin-pages/edit-classroom/edit-classroom-model'
    },
    shim: {
      backbone: {
        deps: ['underscore', 'jquery'],
        exports: 'Backbone'
      },
      underscore: {
        exports: '_'
      },
      bootstrap: {
        deps: ['jquery'],
        exports: '$'
      },
      purl: {
        deps: ['jquery'],
        exports: '$'
      },
      'jquery.ui.core': {
        deps: ['jquery'],
        exports: '$'
      },
      'jquery.ui.mouse': {
        deps: ['jquery', 'jquery.ui.widget'],
        exports: '$'
      },
      'jquery.ui.widget': {
        deps: ['jquery'],
        exports: '$'
      },
      'jquery.ui.sortable': {
        deps: ['jquery', 'jquery.ui.core', 'jquery.ui.mouse', 'jquery.ui.widget'],
        exports: '$'
      },
      'jquery.ui.effect': {
        deps: ['jquery'],
        exports: '$'
      },
      handlebars: {
        exports: 'Handlebars'
      }
    }
  });

}).call(this);

/*
//@ sourceMappingURL=require-config.js.map
*/