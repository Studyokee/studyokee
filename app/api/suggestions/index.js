'use strict';

var Suggestions = require('../../../models/suggestions');

var q = require('q');
var express = require('express');
var app = express();

app.use(function (req, res, next) {
    if (!req.query.hasOwnProperty('fromLanguage')) {
        return res.json(400, {
            error: 'fromLanguage required'
        });
    }
    if (!req.query.hasOwnProperty('toLanguage')) {
        return res.json(400, {
            error: 'toLanguage required'
        });
    }
    q.resolve().then(function () {
        return Suggestions.getSuggestions(req.query.fromLanguage, req.query.toLanguage);
    }).then(function (suggestions) {
        req.suggestions = suggestions;
        next();
    }).fail(function (err) {
        next(new Error(err));
    });
});

app.use('/video', require('./video'));
app.use('/rdio', require('./rdio'));

module.exports = app;