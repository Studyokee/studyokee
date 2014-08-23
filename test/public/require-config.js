(function() {
    requirejs.config({
        enforceDefine: true,
        paths: {
            backbone: '../../../public/bower_components/backbone/backbone',
            jquery: '../../../public/bower_components/jquery/jquery',
            underscore: '../../../public/bower_components/underscore/underscore',
            handlebars: '../../../public/bower_components/handlebars/handlebars',
            'media.item.list.view': '../../../public/lib/media-item-list/media-item-list-view',
            'media.item.view': '../../../public/lib/media-item/media-item-view',
            'subtitles.scroller.view': '../../../public/lib/subtitles-scroller/subtitles-scroller-view',
            'subtitles.player.model': '../../../public/lib/subtitles-player/subtitles-player-model',
            'subtitles.player.view': '../../../public/lib/subtitles-player/subtitles-player-view',
            'subtitles.controls.view': '../../../public/lib/subtitles-controls/subtitles-controls-view',
            'songs.data.provider': '../../../public/lib/songs-data-provider',
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
            handlebars: {
                exports: 'Handlebars'
            }
        }
    });

}).call(this);