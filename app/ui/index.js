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
    ensureAuthenticated,
    function(req, res) {
        res.render('index');
    }
);

app.get('/upload/:rdioKey/:fromLanguage/:toLanguage',
    function(req, res) {
        var data = {
            user: req.user,
            rdioKey: req.params.rdioKey,
            fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage
        };
        res.render('upload', data);
    }
);

app.get('/editsuggestions/:fromLanguage/:toLanguage',
    ensureAuthenticated,
    function(req, res) {
        var data = {
            fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage
        };
        res.render('edit-suggestions', data);
    }
);

module.exports = app;