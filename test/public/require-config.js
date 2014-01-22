(function() {
    requirejs.config({
        enforceDefine: true,
        paths: {
            backbone: '../../../public/bower_components/backbone/backbone',
            jquery: '../../../public/bower_components/jquery/jquery',
            jrdio: '../../../public/bower_components/jquery.rdio/jquery.rdio',
            underscore: '../../../public/bower_components/underscore/underscore',
            handlebars: '../../../public/bower_components/handlebars/handlebars',
            'main.model': '../../../public/lib/main/main-model',
            'main.view': '../../../public/lib/main/main-view',
            'settings': '../../../public/lib/settings',
            'add.song.view': '../../../public/lib/add-song/add-song-view',
            'add.song.model': '../../../public/lib/add-song/add-song-model',
            'song.list.view': '../../../public/lib/song-list/song-list-view',
            'language.settings.view': '../../../public/lib/language-settings/language-settings-view',
            'language.settings.model': '../../../public/lib/language-settings/language-settings-model',
            'subtitles.scroller.view': '../../../public/lib/subtitles-scroller/subtitles-scroller-view',
            'subtitles.player.model': '../../../public/lib/subtitles-player/subtitles-player-model',
            'subtitles.player.view': '../../../public/lib/subtitles-player/subtitles-player-view',
            'subtitles.upload.view': '../../../public/lib/subtitles-upload/subtitles-upload/subtitles-upload-view',
            'subtitles.upload.model': '../../../public/lib/subtitles-upload/subtitles-upload/subtitles-upload-model',
            'subtitles.insert.text.view': '../../../public/lib/subtitles-upload/subtitles-insert-text/subtitles-insert-text-view',
            'subtitles.sync.view': '../../../public/lib/subtitles-upload/subtitles-sync/subtitles-sync-view',
            'subtitles.controls.view': '../../../public/lib/subtitles-controls/subtitles-controls-view',
            'music.player': '../../../public/lib/rdio-player',
            'test.translation.data.provider': '../../../public/lib/test-translation-data-provider',
            'tune.wiki.translation.data.provider': '../../../public/lib/tune-wiki-translation-data-provider',
            'studyokee.translation.data.provider': '../../../public/lib/studyokee-translation-data-provider',
            'suggestions.model': '../../../public/lib/suggestions/suggestions-model',
            'suggestions.view': '../../../public/lib/suggestions/suggestions-view',
            'dictionary.view': '../../../public/lib/dictionary/dictionary-view',
            'dictionary.model': '../../../public/lib/dictionary/dictionary-model',
            templates: '../../../public/lib/templates'
        },
        shim: {
            backbone: {
                deps: ['underscore', 'jquery'],
                exports: 'Backbone'
            },
            underscore: {
                exports: '_'
            },
            jrdio: {
                deps: ['jquery'],
                exports: '$'
            },
            handlebars: {
                exports: 'Handlebars'
            }
        }
    });

}).call(this);