'use strict';

var express = require('express');
var app = express();
var q = require('q');
var Song = require('../../../models/song');
var assert = require('assert');
var Utilities = require('../utilities');
var mongoose = require('mongoose');
var ObjectId = mongoose.Types.ObjectId;

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

        var ids = req.query.ids;
        var _ids = [];
        for (var i = 0; i < ids.length; i++) {
            _ids.push(ObjectId.fromString(ids[i]));
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

app.post('/', Utilities.ensureAuthenticated, function (req, res) {
    q.resolve().then(function () {
        var createdById = null;
        if (req.user) {
            createdById = req.user._id;
        }
        return Song.create(req.body, createdById);
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