'use strict';

var express = require('express');
var app = express();
var q = require('q');
var request = require('request');

app.get('/', function (req, res) {
    q.resolve().then(function () {
        var suggestions = req.suggestions;
        var ids = '';
        for (var i = 0; i < suggestions.videos.length; i++) {
            var suggestion = suggestions.videos[i];
            ids += suggestion;
            if (i !== suggestions.videos.length - 1) {
                ids += ',';
            }
        }
        
        var url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet';
        url += '&key=' + process.env.GOOGLE_API_KEY;
        url += '&id=' + ids;
        request.get({
            url: url,
            json: true
        }, function (err, videosResult) {
            res.json(200, videosResult.body);
        });
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.put('/', function (req, res) {
    var newVideos = req.body.suggestions;
    q.resolve().then(function () {
        var suggestions = req.suggestions;
        var updates = {
            videos: newVideos
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