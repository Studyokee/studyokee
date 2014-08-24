'use strict';

var express = require('express');
var app = express();
var q = require('q');
var Song = require('../../../models/song');
var assert = require('assert');

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
        assert(req.query.hasOwnProperty('ids'));
        return Song.getDisplayInfo(req.query.ids);
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
        assert(req.query.hasOwnProperty('queryString'));
        return Song.searchSongs(req.query.queryString);
    }).then(function (matches) {
        res.json(200, matches);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.post('/', function (req, res) {
    q.resolve().then(function () {
        return Song.create(req.body);
    }).then(function (classroom) {
        res.json(200, classroom);
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