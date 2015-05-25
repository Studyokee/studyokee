'use strict';

var express = require('express');
var app = express();
var q = require('q');

function ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) { return next(); }
    res.json(500, {
        err: 'User is not logged in or does not have permission to do this action'
    });
}

app.get('/:id/subtitles', function (req, res) {
    q.resolve().then(function () {
        var song = req.song;
        return song.getSubtitles();
    }).then(function (subtitles) {
        res.json(200, subtitles);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.put('/:id/subtitles', ensureAuthenticated, function (req, res) {
    q.resolve().then(function () {
        var song = req.song;
        var newSubtitles = req.body.subtitles;

        var updates = {
            subtitles: newSubtitles
        };

        var updateRequest = q.defer();
        song.update(updates, updateRequest.makeNodeResolver());

        return updateRequest;
    }).then(function () {
        res.send(200);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;