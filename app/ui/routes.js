'use strict';

var express = require('express');
var router = express.Router();

var isAuthenticated = function (req, res, next) {
    // if user is authenticated in the session, call the next() to call the next request handler 
    // Passport adds this method to request object. A middleware is allowed to add properties to
    // request and response objects
    console.log('isAuthenticated: ' + req.isAuthenticated());
    if (req.isAuthenticated()) {
        return next();
    }

    // if the user is not authenticated then redirect him to the login page
    res.redirect('/login?redirectUrl=' + req.url);
};

var getDataObject = function (req) {
    return {
        page: '/optimized/app.js',
        user: {
            id: (req.user && req.user._id) ? req.user._id : '',
            username: (req.user && req.user.username) ? req.user.username : '',
            displayName: (req.user && req.user.displayName) ? req.user.displayName : '',
            admin: (req.user && req.user.admin) ? req.user.admin : false
        }
    };
};

module.exports = function(passport){

    /* Handle Login POST */
    router.post('/login', passport.authenticate('login', {
        successRedirect: '/classrooms/',
        failureRedirect: '/login',
        failureFlash : true
    }));

    /* GET Registration Page */
    router.get('/signup', function(req, res){
        var data = getDataObject(req);
        res.render('base', data);
    });

    /* Handle Registration POST */
    router.post('/signup', passport.authenticate('signup', {
        successRedirect: '/',
        failureRedirect: '/signup',
        failureFlash : true
    }));

    /* GET login page. */
    router.get('/login', function(req, res) {
        var data = getDataObject(req);
        res.render('base', data);
    });

    /* Handle Logout */
    router.get('/logout', function(req, res) {
        req.logout();
        res.redirect('/login');
    });

    router.get('/',
        function(req, res) {
            var data = getDataObject(req);
            res.render('base', data);
        }
    );

    router.get('/try', passport.authenticate('create', {
            successRedirect: '/classrooms/1',
            failureRedirect: '/login',
            failureFlash : true
        })
    );

    router.get('*', isAuthenticated,
        function(req, res) {
            var data = getDataObject(req);
            res.render('base', data);
        }
    );

    return router;
};
