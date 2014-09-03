'use strict';

var Classroom = require('../../../models/classroom');

var q = require('q');
var express = require('express');
var app = express();
var utilities = require('../utilities');

// Return all classrooms
app.get('/', function (req, res) {
    q.resolve().then(function () {
        var findRequest = q.defer();
        Classroom.find({}, findRequest.makeNodeResolver());
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

// Return page of classrooms for one language
app.get('/page/:language', function (req, res) {
    var classrooms = {};
    var pageStart = 0;
    if (req.query.pageStart) {
        pageStart = req.query.pageStart;
    }
    var pageSize = 12;
    if (req.query.pageSize) {
        pageSize = req.query.pageSize;
    }

    q.resolve().then(function () {
        var findRequest = q.defer();
        Classroom.find({language: req.params.language}).
            limit(pageSize).
            skip(pageStart).
            sort('-_id').
            exec(findRequest.makeNodeResolver());
        return findRequest.promise;
    }).then(function (classroomsResult) {
        classrooms = classroomsResult;
        var countRequest = q.defer();
        Classroom.count({language: req.params.language}, countRequest.makeNodeResolver());
        return countRequest.promise;
    }).then(function (count) {
        var toReturn = {
            page: classrooms,
            count: count
        };
        res.json(200, toReturn);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

// Create a new classroom
app.post('/', utilities.ensureAuthenticated, function (req, res) {
    q.resolve().then(function () {
        return Classroom.create(req.body.name, req.body.language, req.user._id);
    }).then(function (classroom) {
        res.json(200, classroom);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.use(require('./classroom'));

module.exports = app;