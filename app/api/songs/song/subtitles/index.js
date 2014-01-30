'use strict';

var express = require('express');
var app = express();
var assert = require('assert');
var q = require('q');

app.get('/:id/subtitles', function (req, res) {
    q.resolve().then(function () {
        assert(req.hasOwnProperty('song'));

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

app.put('/:id/subtitles', function (req, res) {
    q.resolve().then(function () {
        assert(req.hasOwnProperty('song'));
        assert(req.body.hasOwnProperty('subtitles'));
        
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