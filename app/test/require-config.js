// 'use strict';

// (function() {
//     requirejs.config({
//         enforceDefine: true,
//         paths: {
//             backbone: '../../public/bower_components/backbone/backbone',
//             jquery: '../../public/bower_components/jquery/jquery',
//             jrdio: '../../public/bower_components/jquery.rdio/jquery.rdio',
//             underscore: '../../public/bower_components/underscore/underscore',
//             handlebars: '../../public/bower_components/handlebars/handlebars',
//             templates: '../../public/lib/templates'
//         },
//         shim: {
//             backbone: {
//                 deps: ['underscore', 'jquery'],
//                 exports: 'Backbone'
//             },
//             underscore: {
//                 exports: '_'
//             },
//             jrdio: {
//                 deps: ['jquery'],
//                 exports: '$'
//             },
//             handlebars: {
//                 exports: 'Handlebars'
//             }
//         }
//     });

// }).call(this);