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

module.exports = function(passport){

    /* Handle Login POST */
    router.post('/login', passport.authenticate('login', {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash : true
    }));

    /* GET Registration Page */
    router.get('/signup', function(req, res){
        var data = {
            page: '/lib/app.js'
        };
        data.user = {
            id: req.user ? req.user._id : '',
            firstName: req.user ? req.user.username : ''
        };
        res.render('base', data);
    });

    /* Handle Registration POST */
    router.post('/signup', passport.authenticate('signup', {
        successRedirect: '/',
        failureRedirect: '/signup',
        failureFlash : true
    }));

    /* GET Home Page */
    // router.get('/home', isAuthenticated, function(req, res){
    //     res.render('home', { user: req.user });
    // });
    /* GET login page. */
    router.get('/login', function(req, res) {
        var data = {
            page: '/lib/app.js'
        };
        data.user = {
            id: req.user ? req.user._id : '',
            firstName: req.user ? req.user.username : ''
        };
        res.render('base', data);
    });

    /* Handle Logout */
    router.get('/logout', function(req, res) {
        req.logout();
        res.redirect('/login');
    });

    router.get('*', isAuthenticated,
        function(req, res) {
            console.log('user: ' + JSON.stringify(req.user, null, 4));
            var data = {
                page: '/lib/app.js'
            };
            data.user = {
                id: req.user ? req.user._id : '',
                firstName: req.user ? req.user.username : ''
            };
            res.render('base', data);
        }
    );

    return router;
};
