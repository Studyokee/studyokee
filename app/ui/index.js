'use strict';

var express = require('express');
var app = express();

app.configure(function() {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'ejs');
});

app.get('/',
    function(req, res) {
        var data = {
            page: '/lib/pages/youtube-main.js'
        };
        res.render('base', data);
    }
);

app.get('/songs/edit',
    function(req, res) {
        var data = {
            page: '/lib/pages/edit-songs.js'
        };
        res.render('base', data);
    }
);

app.get('/songs/:id/edit',
    function(req, res) {
        var data = {
            id: req.params.id,
            page: '/lib/pages/edit-song.js'
        };
        res.render('entity', data);
    }
);

app.get('/classrooms/create',
    function(req, res) {
        var data = {
            page: '/lib/pages/create-classroom.js'
        };
        res.render('base', data);
    }
);
app.get('/classrooms/:id/edit',
    function(req, res) {
        var data = {
            id: req.params.id,
            page: '/lib/pages/edit-classroom.js'
        };
        res.render('entity', data);
    }
);
app.get('/classrooms/:id',
    function(req, res) {
        var data = {
            id: req.params.id,
            page: '/lib/pages/classroom.js'
        };
        res.render('entity', data);
    }
);
app.get('/classrooms/',
    function(req, res) {
        var data = {
            page: '/lib/pages/classrooms.js'
        };
        res.render('base', data);
    }
);

module.exports = app;