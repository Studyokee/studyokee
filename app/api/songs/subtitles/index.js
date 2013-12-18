'use strict';

var express = require('express');
var Song = require('../../../../models/song');
var app = express();
var assert = require('assert');

app.get('/:rdioKey/subtitles', function (req, res) {
    assert(req.hasOwnProperty('rdioData'));

    Song.getSubtitles(req.rdioData.artist, req.rdioData.name).then(function (subtitles) {
        res.json(200, subtitles);
    }).fail(function (err) {
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;