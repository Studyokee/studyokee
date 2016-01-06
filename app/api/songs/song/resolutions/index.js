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

app.get('/:id/resolutions', function (req, res) {
    q.resolve().then(function () {
        var song = req.song;
        res.json(200, song.resolutions);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.put('/:id/resolutions', ensureAuthenticated, function (req, res) {
    q.resolve().then(function () {
        var data = req.body;
        if (!data) {
            return q.reject('No data provided');
        }
        if (!data.word) {
            return q.reject('No word provided');
        }
        if (!data.resolution) {
            return q.reject('No resolution provided');
        }
        var song = req.song;
        var word = data.word.toLowerCase();
        var resolution = data.resolution.toLowerCase();

        var resolutions = song.resolutions;
        if (!resolutions) {
            resolutions = [];
        }
        var updated = false;
        for (var i = 0; i < resolutions.length; i++) {
            if (resolutions[i].word === word) {
                resolutions[i].resolution = resolution;
                updated = true;
                break;
            }
        }

        if (!updated) {
            // new resolution
            resolutions.push({
                word: word,
                resolution: resolution
            });
        }

        var updates = {
            resolutions: resolutions
        };

        console.log(JSON.stringify(updates, null, 4));
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