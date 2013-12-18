'use strict';

var express = require('express');
var passport = require('passport');

var User = require('../../../models/user');
var Song = require('../../../models/song');

var config = {
    rdio_api_key: process.env.RDIO_API_KEY,
    rdio_api_shared: process.env.RDIO_SHARED_SECRET,
    callback_url: '/'
};
var rdio = require('../rdio')(config);

var app = express();

app.configure(function() {
    app.use(passport.initialize());
    app.use(passport.session());
});

function ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) { return next(); }

    res.redirect('/auth/rdio');
}

function getData (req, res, next) {
    var rdioKey = req.params.rdioKey;
    Song.getByRdioKey(rdioKey).then(function (song) {
        User.getByRdioId(req.user.id).then(function (user) {
            var data = {
                keys: [rdioKey],
                method: 'get'
            };

            rdio.api(user.oauth.token, user.oauth.tokenSecret, data, function (err, rdioData) {
                req.song = song;
                req.rdioData = JSON.parse(rdioData).result[rdioKey];
                next();
            });
        });
    });
}

app.get('/:rdioKey/*', ensureAuthenticated, getData);
app.put('/:rdioKey/*', ensureAuthenticated, getData);

app.use(require('./subtitles'));
app.use(require('./translations'));

module.exports = app;