'use strict';

var Classroom = require('../../../models/classroom');

var q = require('q');
var express = require('express');
var app = express();

// Return all classrooms
app.get('/', function (req, res) {
    q.resolve().then(function () {
        var findRequest = q.defer();
        Classroom.findOne({}, findRequest.makeNodeResolver());
        return findRequest.promise;
    }).then(function (classrooms) {
        res.json(200, classrooms);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

// Return classroom by id
app.get('/:id', function (req, res) {
    q.resolve().then(function () {
        var findRequest = q.defer();
        Classroom.findOne({'classroomId': req.params.id}, findRequest.makeNodeResolver());
        return findRequest.promise;
    }).then(function (classroom) {
        res.json(200, classroom);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

// Create a new classroom
app.post('/', function (req, res) {
    q.resolve().then(function () {
        return Classroom.create(req.body.name, req.body.language);
    }).then(function () {
        res.json(200);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

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
        if (req.body.songs) {
            updates.songs = req.body.songs;
        }
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

module.exports = app;