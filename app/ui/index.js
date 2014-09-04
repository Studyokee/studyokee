'use strict';

var express = require('express');
var app = express();

app.configure(function() {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'ejs');
});

app.get('*',
    function(req, res) {
        console.log('user: ' + JSON.stringify(req.user, null, 4));
        var data = {
            page: '/lib/app.js'
        };
        data.user = {
            id: req.user ? req.user._id : '',
            displayName: req.user ? req.user.displayName : '',
            photo: req.user ? req.user.photo : '',
            firstName: req.user ? req.user.firstName : ''
        };
        res.render('base', data);
    }
);

module.exports = app;