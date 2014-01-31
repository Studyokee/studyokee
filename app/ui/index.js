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
        res.render('rdio');
    }
);

app.get('/video',
    function(req, res) {
        res.render('youtube');
    }
);

app.get('/songs/edit',
    function(req, res) {
        res.render('edit-songs');
    }
);

app.get('/songs/edit/:id',
    function(req, res) {
        var data = {
            id: req.params.id
        };
        res.render('edit-song', data);
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

module.exports = app;