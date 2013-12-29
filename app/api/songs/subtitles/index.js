'use strict';

var express = require('express');
var Song = require('../../../../models/song');
var app = express();
var assert = require('assert');
var q = require('q');

app.get('/:rdioKey/subtitles', function (req, res) {
    assert(req.hasOwnProperty('song'));

    q.resolve().then(function () {
        return Song.getSubtitles(req.song.rdioData.artist, req.song.rdioData.name);
    }).then(function (subtitles) {
        res.json(200, subtitles);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;