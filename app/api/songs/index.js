'use strict';


var express = require('express');
var passport = require('passport');
var app = express();

app.configure(function() {
    app.use(passport.initialize());
    app.use(passport.session());
});

var Song = require('../../../models/song');
var rdio = require('../../../lib/rdio');

function ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) { return next(); }
    res.redirect('/auth/rdio');
}

function getData (req, res, next) {
    var rdioKey = req.params.rdioKey;
    Song.getByRdioKey(rdioKey).then(function (song) {
        if (song.rdioData) {
            req.song = song;
            next();
        }

        var data = {
            keys: [rdioKey],
            method: 'get'
        };
        rdio.api(null, null, data, function (err, rdioResult) {
            var rdioData = JSON.parse(rdioResult).result[rdioKey];
            
            var updates = {
                rdioData: rdioData
            };
            song.update(updates);
            
            song.rdioData = rdioData;
            req.song = song;
            next();
        });
    });
}

app.get('/subtitles/rdio/:rdioKey', ensureAuthenticated, getData);
app.put('/subtitles/rdio/:rdioKey', ensureAuthenticated, getData);

app.get('/translations/rdio/:rdioKey/*', ensureAuthenticated, getData);
app.put('/translations/rdio/:rdioKey/*', ensureAuthenticated, getData);

app.use('/subtitles', require('./subtitles'));
app.use('/translations', require('./translations'));

module.exports = app;