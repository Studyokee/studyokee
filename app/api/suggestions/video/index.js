'use strict';

var express = require('express');
var app = express();
var q = require('q');
var request = require('request');
var Song = require('../../../../models/song');

app.get('/', function (req, res) {
    q.resolve().then(function () {
        var suggestions = req.suggestions;
        var getRequest = q.defer();
        Song.find({
            _id: {$in: suggestions.videos}
        }, getRequest.makeNodeResolver());
        return getRequest.promise;
    }).then(function (songs) {
        var videoIds = [];
        for (var i = 0; i < songs.length; i++) {
            videoIds.push(songs[i].youtubeKey);
        }

        var url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet';
        url += '&key=' + process.env.GOOGLE_API_KEY;
        url += '&id=' + videoIds.join();
        console.log('url: ' + url);
        request.get({
            url: url,
            json: true
        }, function (err, videosResult) {
            var toReturn = {
                songs: songs,
                videos: videosResult.body.items
            };
            res.json(200, toReturn);
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