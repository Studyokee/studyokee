(function() {
    requirejs.config({
        enforceDefine: true,
        paths: {
            backbone: '../../../public/bower_components/backbone/backbone',
            jquery: '../../../public/bower_components/jquery/jquery',
            jrdio: '../../../public/bower_components/jquery.rdio/jquery.rdio',
            underscore: '../../../public/bower_components/underscore/underscore',
            handlebars: '../../../public/bower_components/handlebars/handlebars',
            'media.item.list.view': '../../../public/lib/media-item-list/media-item-list-view',
            'media.item.view': '../../../public/lib/media-item/media-item-view',
            'subtitles.scroller.view': '../../../public/lib/subtitles-scroller/subtitles-scroller-view',
            'subtitles.player.model': '../../../public/lib/subtitles-player/subtitles-player-model',
            'subtitles.player.view': '../../../public/lib/subtitles-player/subtitles-player-view',
            'subtitles.controls.view': '../../../public/lib/subtitles-controls/subtitles-controls-view',
            'rdio.player.model': '../../../public/lib/rdio/rdio-player/rdio-player-model',
            'rdio.player.view': '../../../public/lib/rdio/rdio-player/rdio-player-view',
            'songs.data.provider': '../../../public/lib/songs-data-provider',
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