'use strict';

var express = require('express');
var app = express();
var q = require('q');
var rdio = require('../../../../lib/rdio');
var Song = require('../../../../models/song');

app.get('/', function (req, res) {
    var suggestions = req.suggestions;
    q.resolve().then(function () {
        var getRequest = q.defer();
        Song.find({
            _id: {$in: suggestions.songs}
        }, getRequest.makeNodeResolver());
        return getRequest.promise;
    }).then(function (songs) {
        var rdioKeys = [];
        for (var i = 0; i < songs.length; i++) {
            rdioKeys.push(songs[i].rdioKey);
        }
        var data = {
            keys: rdioKeys,
            method: 'get'
        };

        var rdioRequest = q.defer();
        rdio.api(null, null, data, rdioRequest.makeNodeResolver());
        return rdioRequest.promise.spread(function (rdioResult) {
            console.log('Retrieved keys from Rdio');
            var parsedResult = JSON.parse(rdioResult);
            if (parsedResult.result) {
                var rdioSuggestions = [];
                for (var i = 0; i < rdioKeys.length; i++) {
                    var rdioKey = rdioKeys[i];
                    rdioSuggestions.push(parsedResult.result[rdioKey]);
                }
                var toReturn = {
                    songs: songs,
                    rdioSongs: rdioSuggestions
                };
                res.json(200, toReturn);
            } else {
                res.json(200, []);
            }
        });
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.put('/', function (req, res) {
    var newSongs = req.body.suggestions;
    q.resolve().then(function () {
        var suggestions = req.suggestions;
        var updates = {
            songs: newSongs
        };

        var updateRequest = q.defer();
        suggestions.update(updates, updateRequest.makeNodeResolver());
        return updateRequest.promise;
    }).then(function () {
        res.json(200);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;