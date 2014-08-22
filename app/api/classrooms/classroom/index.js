'use strict';

var express = require('express');
var app = express();
var q = require('q');
var Classroom = require('../../../../models/classroom');
var mongoose = require('mongoose');

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

app.use(function (req, res) {
    res.json(404, {});
});
/*jshint unused:false*/
app.use(function (err, req, res, next) {
    res.json(500, { error: err});
});
/*jshint unused:true*/

module.exports = app;