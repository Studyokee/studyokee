'use strict';

var express = require('express');
var app = express();
var passport = require('passport');

app.configure(function() {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'ejs');
    app.use(passport.initialize());
    app.use(passport.session());
});

function ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) { return next(); }

    res.redirect('/auth/rdio');
}

app.get('/',
    function(req, res) {
        res.redirect('/video');
    }
);

app.get('/rdio',
    ensureAuthenticated,
    function(req, res) {
        var data = {
            page: '/lib/pages/rdio-main.js'
        };
        res.render('base', data);
    }
);

app.get('/video',
    function(req, res) {
        var data = {
            page: '/lib/pages/youtube-main.js'
        };
        res.render('base', data);
    }
);

app.get('/songs/edit',
    function(req, res) {
        var data = {
            page: '/lib/pages/edit-songs.js'
        };
        res.render('base', data);
    }
);

app.get('/songs/edit/:id',
    function(req, res) {
        var data = {
            id: req.params.id,
            page: '/lib/pages/edit-song.js'
        };
        res.render('entity', data);
    }
);

app.get('/suggestions/:fromLanguage/:toLanguage',
    function(req, res) {
        var data = {
            fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage
        };
        res.render('edit-suggestions', data);
    }
);

app.get('/classrooms/create',
    function(req, res) {
        var data = {
            page: '/lib/pages/create-classroom.js'
        };
        res.render('base', data);
    }
);
app.get('/classrooms/edit/:id',
    function(req, res) {
        var data = {
            id: req.params.id,
            page: '/lib/pages/edit-classroom.js'
        };
        res.render('entity', data);
    }
);
app.get('/classrooms/:id',
    function(req, res) {
        var data = {
            id: req.params.id,
            page: '/lib/pages/classroom.js'
        };
        res.render('entity', data);
    }
);
app.get('/classrooms/',
    function(req, res) {
        var data = {
            page: '/lib/pages/classrooms.js'
        };
        res.render('base', data);
    }
);

module.exports = app;