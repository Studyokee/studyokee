'use strict';

var express = require('express');
var passport = require('passport');
var User = require('../../../models/user');

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

app.get('/:query',
    ensureAuthenticated,
    function (req, res) {
        console.log('Query: ' + req.params.query);
        User.getByRdioId(req.user.id).then(function (user) {
            var data = {
                query: req.params.query,
                types: ['Track'],
                method: 'search'
            };

            rdio.api(user.oauth.token, user.oauth.tokenSecret, data, function (err, searchResults) {
                res.json(200, searchResults);
            });
        });
    }
);

module.exports = app;