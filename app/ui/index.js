'use strict';

var express = require('express');
var app = express();

app.configure(function() {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'ejs');
});

app.get('*',
    function(req, res) {
        var userId = req.user ? req.user._id : '';
        var data = {
            page: '/lib/app.js',
            userId: userId
        };
        res.render('base', data);
    }
);

module.exports = app;