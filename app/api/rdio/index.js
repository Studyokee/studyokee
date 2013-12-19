'use strict';

var express = require('express');
var passport = require('passport');
var q = require('q');
var User = require('../../../models/user');

var config = {
    rdio_api_key: process.env.RDIO_API_KEY,
    rdio_api_shared: process.env.RDIO_SHARED_SECRET,
    callback_url: '/'
};
var rdio = require('./rdio')(config);

var app = express();

app.configure(function() {
    app.use(passport.initialize());
    app.use(passport.session());
});

function ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) { return next(); }
    res.redirect('/auth/rdio');
}

app.get('/search/:query',
    function (req, res) {
        q.resolve().then(function () {
            console.log('Query: ' + req.params.query);
            var data = {
                query: req.params.query,
                types: ['Track'],
                method: 'search'
            };

            rdio.api(null, null, data, function (err, rdioResults) {
                var searchResults = JSON.parse(rdioResults).result.results;
                res.json(200, searchResults);
            });
        }).fail(function (err) {
            console.log(err);
            res.json(500, {
                err: err
            });
        });
    }
);

app.get('/getPlaybackToken',
    ensureAuthenticated,
    function (req, res) {
        q.resolve().then(function () {
            User.getByRdioId(req.user.id).then(function (user) {
                console.log('host: ' + req.host);
                rdio.getPlaybackToken(user.oauth.token, user.oauth.tokenSecret, req.host, function (err, rdioResults) {
                    var token = JSON.parse(rdioResults).result;
                    res.json(200, token);
                });
            });
        }).fail(function (err) {
            console.log(err);
            res.json(500, {
                err: err
            });
        });
    }
);

module.exports = app;