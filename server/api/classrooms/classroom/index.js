'use strict';

var express = require('express');
var app = express();
var q = require('q');
var Classroom = require('../../../../models/classroom');
var Song = require('../../../../models/song');
var utilities = require('../../utilities');

function getClassroom (req, res, next) {
    q.resolve().then(function () {
        var findRequest = q.defer();
        Classroom.findOne({'classroomId': req.params.id}, findRequest.makeNodeResolver());
        return findRequest.promise;
    }).then(function (classroom) {
        req.classroom = classroom;
        next();
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
}

function checkPermission (req, res, next) {
    if (req.classroom.createdById === req.user._id.toString() || req.user.admin === true) { return next(); }
    res.json(500, {
        err: 'This user does not have permission to edit this classroom'
    });
}

// Return classroom by id
app.get('/:id', getClassroom, function (req, res) {
    q.resolve().then(function () {
        return Song.getDisplayInfo(req.classroom.songs);
    }).then(function (displayInfos) {
        var toReturn = {
            classroom: req.classroom,
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

app.delete('/:id', utilities.ensureAuthenticated, getClassroom, checkPermission, function (req, res) {
    console.log('Delete: ' + req.params.id);
    q.resolve().then(function () {
        var deleteRequest = q.defer();
        Classroom.remove(req.classroom, deleteRequest.makeNodeResolver());
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

// curl -H 'Content-Type: application/json' -X PUT -d '{"name":"123","songs":["52c2e9829759093a19000002", "52d5f0e23025f1bf12000002"]}' http://localhost:3000/api/classrooms/10
// Edit a classroom
app.put('/:id', utilities.ensureAuthenticated, getClassroom, checkPermission, function (req, res) {
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