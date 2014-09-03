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