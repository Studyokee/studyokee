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
        res.redirect('/rdio');
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
        res.render('video');
    }
);

app.get('/songs/:rdioKey/:toLanguage',
    function(req, res) {
        var data = {
            user: req.user,
            rdioKey: req.params.rdioKey,
            toLanguage: req.params.toLanguage
        };
        res.render('upload', data);
    }
);

app.get('/suggestions/:fromLanguage/:toLanguage',
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