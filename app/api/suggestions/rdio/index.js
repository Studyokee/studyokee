'use strict';

var express = require('express');
var app = express();
var q = require('q');
var rdio = require('../../../../lib/rdio');

app.get('/', function (req, res) {
    q.resolve().then(function () {
        var suggestions = req.suggestions;
        var data = {
            keys: suggestions.songs,
            method: 'get'
        };

        var rdioRequest = q.defer();
        rdio.api(null, null, data, rdioRequest.makeNodeResolver());
        return rdioRequest.promise.spread(function (rdioResult) {
            console.log('Retrieved keys from Rdio');
            var parsedResult = JSON.parse(rdioResult);
            if (parsedResult.result) {
                var rdioSuggestions = [];
                for (var i = 0; i < suggestions.songs.length; i++) {
                    var rdioKey = suggestions.songs[i];
                    rdioSuggestions.push(parsedResult.result[rdioKey]);
                }
                res.json(200, rdioSuggestions);
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