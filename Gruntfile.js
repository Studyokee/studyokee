'use strict';

module.exports = function (grunt) {
    // load all grunt tasks
    require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
    grunt.loadTasks('tasks');
    // show elapsed time at the end
    require('time-grunt')(grunt);
    // load all grunt tasks
    require('load-grunt-tasks')(grunt);
    grunt.loadNpmTasks('grunt-coffeelint');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-connect');

    grunt.initConfig({
        env: {
            development: {
                PORT: 3000,
                MONGOHQ_URL: 'mongodb://localhost/studyokee',
                src: '.env',
                URL: 'http://localhost:'
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
            coffee: {
                files: [
                    'public/src/**/*.coffee'
                ],
                tasks: [
                    'coffeelint',
                    'coffee'
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
            sass: {
                files: ['public/src/**/*.scss',],
                tasks: [
                    'sass'
                ]
            },
            compass: {
                files: ['public/styles/{,*/}*.{scss,sass}'],
                tasks: ['compass:server', 'autoprefixer']
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
                        '!components/**/*',
                        '!node_modules/**/*'
                    ]
                },
                options: {
                    'max_line_length': {
                        level: 'warn'
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
                    '!app/api/rdio/rdio.js'
                ],
                options: {
                    jshint: {
                        'node': true,
                        'browser': false,
                        'esnext': true,
                        'bitwise': true,
                        'camelcase': false,
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
                        'console': false
                    }
                }
            }
        },
        mochaTest: {
            files: [
                'test/**/*.js'
            ]
        },
        mochaTestConfig: {
            options: {
                reporter: 'json-stream'
            }
        },
        requirejs: {
        },
        compass: {
            options: {
                sassDir: 'public/styles',
                cssDir: '.tmp/styles',
                generatedImagesDir: '.tmp/images/generated',
                imagesDir: 'public/images',
                javascriptsDir: 'public/scripts',
                fontsDir: 'public/styles/fonts',
                importPath: 'public/bower_components',
                httpImagesPath: '/images',
                httpGeneratedImagesPath: '/images/generated',
                httpFontsPath: '/styles/fonts',
                relativeAssets: false,
                assetCacheBuster: false
            },
            server: {
                options: {
                    debugInfo: true
                }
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
        sass: {
            dist: {
                options: {
                    style: 'compressed'
                },
                files: {
                    'public/styles/main.css': 'public/styles/main.scss'
                }
            },
            dev: {
                options: {
                    style: 'expanded'
                },
                files: {
                    'public/styles/main.css': 'public/styles/main.scss'
                }
            }
        },
        connect: {
            server: {
                options: {
                    port: 3000,
                    // change this to '0.0.0.0' to access the server from outside
                    hostname: 'localhost'
                }
            }
        }
    });
    grunt.registerTask('preprocessor', [
        'jshint2',
        'coffeelint',
        'coffee',
        'handlebars',
        'sass'
    ]);
    grunt.registerTask('keep-alive', function () {
        this.async();
    });
    grunt.registerTask('travis', ['env:travis', 'mochaTest']);
    grunt.registerTask('test', ['env:test', 'mongod', 'mochaTest']);
    grunt.registerTask('default', ['env:development', 'preprocessor', 'autoprefixer', 'compass', 'mongod', 'server', 'watch']);
};
