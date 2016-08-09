'use strict';

module.exports = function (grunt) {
    // load all grunt tasks
    require('matchdep').filter('grunt-*').forEach(grunt.loadNpmTasks);
    grunt.loadTasks('tasks');
    // show elapsed time at the end
    require('time-grunt')(grunt);

    var DEFAULT_PORT = 3000;

    grunt.loadNpmTasks('grunt-contrib-requirejs');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-casperjs');
    grunt.loadNpmTasks('grunt-run');

    grunt.initConfig({
        env: {
            development: {
                PORT: DEFAULT_PORT,
                MONGOHQ_URL: 'mongodb://localhost/studyokee',
                src: '.env',
                URL: 'http://localhost:' + DEFAULT_PORT
            },
            test: {
                MONGOHQ_URL: 'mongodb://localhost/studyokee-test',
                src: '.env'
            },
            travis: {
                MONGOHQ_URL: 'mongodb://localhost/studyokee-test'
            }
        },
        watch: {
            options: {
                livereload: true,
            },
            coffee: {
                files: [
                    'public/src/**/*.coffee'
                ],
                tasks: [
                    'newer:coffeelint',
                    'newer:coffee',
                    'newer:copy:main'
                ]
            },
            handlebars: {
                files: [
                    'public/src/**/*.handlebars'
                ],
                tasks: [
                    'handlebars'
                ]
            },
            stylus: {
                files: ['public/**/*.styl'],
                tasks: [
                    'stylus'
                ]
            },
            styles: {
                files: ['public/styles/{,*/}*.css'],
                tasks: ['autoprefixer']
            }
        },
        handlebars: {
            compile: {
                options: {
                    namespace: 'Handlebars.templates',
                    amd: true,
                    processName: function(filename) {
                        var path = require('path');
                        return path.basename(filename, '.handlebars');
                    }
                },
                files: {
                    'public/lib/templates.js': 'public/src/**/*.handlebars'
                }
            }
        },
        coffee: {
            compile: {
                cwd: 'public/src/',
                src: ['**/*.coffee'],
                dest: 'public/lib/',
                ext: '.js',
                expand: true,
                options: {
                    runtime: 'inline',
                    sourceMap: true
                }
            }
        },
        coffeelint: {
            app: {
                files: {
                    src: [
                        'public/src/**/*.coffee',
                        '!public/bower_components/**/*'
                    ]
                },
                options: {
                    'max_line_length': {
                        level: 'ignore'
                    },
                    'no_unnecessary_fat_arrows': {
                        level: 'ignore'
                    }
                }
            }
        },
        jshint2: {
            server: {
                src: [
                    '**/*.js',
                    '!node_modules/**/*.js',
                    '!public/**/*.js',
                    '!test/public/require-config.js',
                    '!assets/*.js'
                ],
                options: {
                    jshint: {
                        'node': true,
                        'browser': false,
                        'esnext': true,
                        'bitwise': true,
                        'camelcase': true,
                        'curly': true,
                        'eqeqeq': true,
                        'immed': true,
                        'indent': 4,
                        'latedef': true,
                        'newcap': true,
                        'noarg': true,
                        'quotmark': 'single',
                        'regexp': true,
                        'undef': true,
                        'unused': true,
                        'strict': true,
                        'trailing': true,
                        'smarttabs': true
                    },
                    globals: {
                        'describe': false,
                        'it': false,
                        'beforeEach': false,
                        'afterEach': false,
                        'before': false,
                        'console': false,
                        'expect': false,
                        'define': false,
                        'spyOn': false,
                        'waitsFor': false,
                        '$': false,
                        'runs': false
                    }
                }
            }
        },
        jasmine: {
            all: 'test/public/index.html'
        },
        mochaTest: {
            files: [
                'test/app/**/*.js',
                'test/models/**/*.js',
                'test/utils/**/*.js'
            ]
        },
        mochaTestConfig: {
            options: {
                reporter: 'json-stream'
            }
        },
        autoprefixer: {
            options: {
                browsers: ['last 1 version']
            },
            dist: {
                files: [{
                    expand: true,
                    cwd: '.tmp/styles/',
                    src: '{,*/}*.css',
                    dest: '.tmp/styles/'
                }]
            }
        },
        bower: {
            options: {
                exclude: ['modernizr']
            },
            all: {
                rjsConfig: 'public/scripts/main.js'
            }
        },
        stylus: {
            dist: {
                options: {
                    compress: true
                },
                files: {
                    'public/styles/main.css': 'public/styles/main.styl'
                }
            },
            dev: {
                options: {
                    compress: false
                },
                files: {
                    'public/styles/main.css': 'public/styles/main.styl',
                }
            }
        },
        copy: {
            main: {
                expand: true,
                cwd: 'public/lib',
                src: '**',
                dest: 'public/optimized/',
            }
        },
        requirejs: {
            compile: {
                options: {
                    appDir: 'public/lib',
                    dir: 'public/optimized',
                    baseUrl: '.',
                    //mainConfigFile: 'public/lib/require-config.js',
                    //name: 'path/to/almond', /* assumes a production build using almond, if you don't use almond, you
                    //                           need to set the "includes" or "modules" option instead of name */
                    //include: [ 'src/main.js' ],
                    paths: {
                        'backbone': '../bower_components/backbone/backbone',
                        'jquery': '../bower_components/jquery/jquery.min',
                        'bootstrap': '../bower_components/bootstrap/dist/js/bootstrap.min',
                        'jquery.ui.core': '../bower_components/jquery-ui/ui/minified/jquery.ui.core.min',
                        'jquery.ui.mouse': '../bower_components/jquery-ui/ui/minified/jquery.ui.mouse.min',
                        'jquery.ui.widget': '../bower_components/jquery-ui/ui/minified/jquery.ui.widget.min',
                        'jquery.ui.sortable': '../bower_components/jquery-ui/ui/minified/jquery.ui.sortable.min',
                        'jquery.ui.effect': '../bower_components/jquery-ui/ui/minified/jquery.ui.effect.min',
                        'underscore': '../bower_components/underscore/underscore-min',
                        'handlebars': '../bower_components/handlebars/handlebars.min',
                        'purl': '../bower_components/purl/purl',
                        'templates': 'templates',
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
                            deps: [ 'underscore', 'jquery' ],
                            exports: 'Backbone'
                        },
                        underscore: {
                            exports: '_'
                        },
                        bootstrap: {
                            deps: [ 'jquery' ],
                            exports: '$'
                        },
                        purl: {
                            deps: [ 'jquery' ],
                            exports: '$'
                        },
                        'jquery.ui.core': {
                            deps: [ 'jquery' ],
                            exports: '$'
                        },
                        'jquery.ui.mouse': {
                            deps: [ 'jquery', 'jquery.ui.widget' ],
                            exports: '$'
                        },
                        'jquery.ui.widget': {
                            deps: [ 'jquery' ],
                            exports: '$'
                        },
                        'jquery.ui.sortable': {
                            deps: [ 'jquery', 'jquery.ui.core', 'jquery.ui.mouse', 'jquery.ui.widget' ],
                            exports: '$'
                        },
                        'jquery.ui.effect': {
                            deps: [ 'jquery' ],
                            exports: '$'
                        },
                        handlebars: {
                            exports: 'Handlebars'
                        }
                    },
                    modules: [
                        {
                            name: 'app',
                            include: [
                                'home.model',
                                'home.view',
                                'login.view',
                                'signup.view',
                                'classroom.view',
                                'classroom.model',
                                'vocabulary.view',
                                'vocabulary.model',
                                'classrooms.view',
                                'classrooms.model',
                            ]
                        }
                    ]
                }
            }
        },
        casperjs: {
            options: {
                async: {
                    parallel: false
                },
                silent: false
            },
            files: ['test/public/**/*.js']
        },
        run: {
            stopserver: {
                cmd: 'killall',
                args: [
                    'node'
                ]
            }
        },
    });

    grunt.registerTask('lint', [
        'jshint2',
        'coffeelint'
    ]);
    grunt.registerTask('preprocessor', [
        'coffee',
        'handlebars',
        'stylus',
        'autoprefixer'
    ]);
    grunt.registerTask('keep-alive', function () {
        this.async();
    });
    grunt.registerTask('travis', ['lint', 'env:travis', 'mochaTest']);
    // grunt.registerTask('test', ['env:development', 'mongod', 'mochaTest']);
    grunt.registerTask('tst', ['env:development', 'mongod', 'server', 'casperjs', 'run:stopserver']);
    grunt.registerTask('default', ['env:development', 'lint', 'preprocessor', 'copy:main', 'mongod', 'server', 'watch']);
    grunt.registerTask('prodtest', ['env:development', 'lint', 'preprocessor', 'requirejs', 'mongod', 'server', 'watch']);
};
