'use strict';

var express = require('express');
var app = express();
var q = require('q');
var Song = require('../../../models/song');
var utilities = require('../utilities');
var mongoose = require('mongoose');
var request = require('request');

// function trimPrefix (req, res, next) {
//     var match = req.url.match('/[^\/]*(.*)');

//     req.url = match[1].length ? match[1] : '/';
//     next();
// }

app.get('/', function (req, res) {
    q.resolve().then(function () {
        return Song.getAllSongs();
    }).then(function (songs) {
        res.json(200, songs);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.get('/display', function (req, res) {
    q.resolve().then(function () {
        var ids = req.query.ids;
        var _ids = [];
        for (var i = 0; i < ids.length; i++) {
            _ids.push(mongoose.Types.ObjectId(ids[i]));
        }

        return Song.getDisplayInfo(_ids);
    }).then(function (displayInfos) {
        res.json(200, displayInfos);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.get('/search', function (req, res) {
    q.resolve().then(function () {
        return Song.searchSongs(req.query.queryString, req.query.language);
    }).then(function (matches) {
        var ids = [];
        for (var i = 0; i < matches.length; i++) {
            ids.push(matches[i]._id);
        }
        return Song.getDisplayInfo(ids);
    }).then(function (displayInfos) {
        res.json(200, displayInfos);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.post('/', utilities.ensureAuthenticated, function (req, res) {
    q.resolve().then(function () {
        return Song.create(req.body.artist, req.body.trackName, req.body.language, req.body.youtubeKey);
    }).then(function (song) {
        res.json(200, song);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

function getYoutubeSongInfo(id) {
    return q.resolve().then(function () {
        var getVideoRequest = q.defer();
        var url = '';
        url = 'https://www.googleapis.com/youtube/v3/videos?';
        url += 'id=' + id;
        url += '&key=' + process.env.YOUTUBE_API_KEY;
        url += '&fields=items(snippet(title))&part=snippet';
        console.log('url: ' + url);
        request(url, getVideoRequest.makeNodeResolver());
        return getVideoRequest.promise;
    }).spread(function (res, body) {
        console.log('worked!');
        // transform result shape
        var result = JSON.parse(body);
        if (result && result.items.length > 0 && result.items[0].snippet) {
            return result.items[0].snippet.title;
        }
        return result;
    });
}

app.get('/youtube/:id', utilities.ensureAuthenticated, function (req, res) {
    q.resolve().then(function () {
        return getYoutubeSongInfo(req.params.id);
    }).then(function (result) {
        res.json(200, result);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.use(require('./song'));

app.use(function (req, res) {
    res.json(404, {});
});
/*jshint unused:false*/
app.use(function (err, req, res, next) {
    res.json(500, { error: err});
});
/*jshint unused:true*/

module.exports = app;