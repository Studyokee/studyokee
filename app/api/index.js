'use strict';

var express = require('express');
var app = express();

app.use(function (req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    
    if ('OPTIONS' === req.method) {
        res.send(200);
    } else {
        next();
    }
});
app.use(express.json());
app.use('/songs', require('./songs'));
app.use('/dictionary', require('./dictionary'));
app.use('/classrooms', require('./classrooms'));
app.use('/vocabulary', require('./vocabulary'));

module.exports = app;