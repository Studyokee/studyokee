'use strict';

var express = require('express');
var app = express();
var q = require('q');
var Song = require('../../../../models/song');
var mongoose = require('mongoose');

app.delete('/:id', function (req, res) {
    console.log('Delete: ' + req.params.id);
    q.resolve().then(function () {
        var deleteRequest = q.defer();
        Song.remove({
            '_id': new mongoose.Types.ObjectId(req.params.id)
        }, deleteRequest.makeNodeResolver());
        return deleteRequest.promise;
    }).then(function () {
        res.json(200, {});
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

function getSong (req, res, next) {
    console.log('getSong');
    q.resolve().then(function () {
        return Song.getByQuery({
            '_id': new mongoose.Types.ObjectId(req.params.id)
        });
    }).then(function (song) {
        req.song = song;
        next();
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
}

app.get('/:id*', getSong);
app.put('/:id*', getSong);

app.get('/:id', function (req, res) {
    console.log('/:id get');
    q.resolve().then(function () {
        res.json(200, req.song);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.put('/:id', function (req, res) {
    var song = req.body.song;
    var set = {};
    if (song.metadata) {
        set.metadata = {
            artist: song.metadata.artist,
            trackName: song.metadata.trackName,
            language: song.metadata.language
        };
    }
    if (song.subtitles) {
        set.subtitles = song.subtitles;
    }
    if (song.translations) {
        set.translations = song.translations;
    }
    if (song.youtubeKey) {
        set.youtubeKey = song.youtubeKey;
    }
    var updates = {
        '$set': set
    };
    console.log(JSON.stringify(updates));
    q.resolve().then(function () {
        var updateRequest = q.defer();
        Song.update({_id: req.params.id}, updates, {}, updateRequest.makeNodeResolver());

        return updateRequest;
    }).then(function () {
        console.log('Updated Song to: ' + JSON.stringify(updates, null, 4));
        res.send(200);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.use(require('./subtitles'));
app.use(require('./translations'));

app.use(function (req, res) {
    res.json(404, {});
});
/*jshint unused:false*/
app.use(function (err, req, res, next) {
    res.json(500, { error: err});
});
/*jshint unused:true*/

module.exports = app;