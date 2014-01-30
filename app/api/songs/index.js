'use strict';

var express = require('express');
var app = express();
var q = require('q');
var Song = require('../../../models/song');

function getAllSongs () {
    var findAllRequest = q.defer();
    Song.find({}, findAllRequest.makeNodeResolver());
    return findAllRequest.promise;
}

// function trimPrefix (req, res, next) {
//     var match = req.url.match('/[^\/]*(.*)');

//     req.url = match[1].length ? match[1] : '/';
//     next();
// }

app.get('/', function (req, res) {
    q.resolve().then(function () {
        return getAllSongs();
    }).then(function (songs) {
        res.json(200, songs);
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