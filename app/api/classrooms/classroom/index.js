'use strict';

var express = require('express');
var app = express();
var q = require('q');
var Classroom = require('../../../../models/classroom');
var mongoose = require('mongoose');
var Song = require('../../../../models/song');

app.delete('/:id', function (req, res) {
    console.log('Delete: ' + req.params.id);
    q.resolve().then(function () {
        var deleteRequest = q.defer();
        Classroom.remove({
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

// Return classroom by id
app.get('/:id', function (req, res) {
    var classroom = null;
    q.resolve().then(function () {
        var findRequest = q.defer();
        Classroom.findOne({'classroomId': req.params.id}, findRequest.makeNodeResolver());
        return findRequest.promise;
    }).then(function (classroomResult) {
        classroom = classroomResult;
        return Song.getDisplayInfo(classroom.songs);
    }).then(function (displayInfos) {
        var toReturn = {
            classroom: classroom,
            displayInfos: displayInfos
        };
        res.json(200, toReturn);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

// curl -H 'Content-Type: application/json' -X PUT -d '{"name":"123","songs":["52c2e9829759093a19000002", "52d5f0e23025f1bf12000002"]}' http://localhost:3000/api/classrooms/10
// Edit a classroom
app.put('/:id', function (req, res) {
    q.resolve().then(function () {
        var findRequest = q.defer();
        Classroom.findOne({'classroomId': req.params.id}, findRequest.makeNodeResolver());
        return findRequest.promise;
    }).then(function (classroom) {
        var updates = {};
        if (req.body.name) {
            updates.name = req.body.name;
        }
        if (req.body.language) {
            updates.language = req.body.language;
        }
        if (!req.body.name || !req.body.language) {
            if (!req.body.songs) {
                updates.songs = [];
            } else {
                updates.songs = req.body.songs;
            }
        }
        console.log('Updating classroom with: ' + JSON.stringify(updates, null, 4));
        var updateRequest = q.defer();
        classroom.update(updates, updateRequest.makeNodeResolver());
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

app.use(function (req, res) {
    res.json(404, {});
});
/*jshint unused:false*/
app.use(function (err, req, res, next) {
    res.json(500, { error: err});
});
/*jshint unused:true*/

module.exports = app;