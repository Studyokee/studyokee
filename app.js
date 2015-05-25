'use strict';

var mongoose = require('mongoose');
mongoose.connect(process.env.MONGOHQ_URL);

var express = require('express');
var app = express();
var User = require('./models/user');

var passport = require('passport');
var FacebookStrategy = require('passport-facebook').Strategy;

app.use(express.logger());
app.use(express.cookieParser());
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.session({ secret: 'keyboard cat' }));
app.use(express.static(__dirname + '/public'));

app.use(passport.initialize());
app.use(passport.session());

passport.use(new FacebookStrategy({
        clientID: process.env.FACEBOOK_APP_ID,
        clientSecret: process.env.FACEBOOK_APP_SECRET,
        callbackURL: process.env.URL + '/auth/facebook/callback',
        profileFields: ['id', 'displayName', 'photos', 'name']
    },
    function(accessToken, refreshToken, profile, done) {
        User.findOrCreate({ facebookId: profile.id }).then(function (user) {
            var photo = '';
            if (profile.photos && profile.photos.length > 0) {
                photo = profile.photos[0].value;
            }
            var displayName = profile.displayName;
            var firstName = profile.name.givenName;

            var updates = {};
            updates.photo = photo;
            updates.displayName = displayName;
            updates.firstName = firstName;
            user.update(updates);

            user.photo = photo;
            user.displayName = displayName;
            user.firstName = firstName;

            return done(null, user);
        });
    })
);

passport.serializeUser(function(user, done) {
    console.log('serialiaze user: ' + JSON.stringify(user));
    done(null, user);
});

passport.deserializeUser(function(user, done) {
    console.log('deserialiaze user: ' + JSON.stringify(user));
    //returns a q promise
    done(null, user);
});

app.get('/auth/facebook',
    function(req, res, next) {
        req.session.redirectUrl = req.query.callbackURL;
        next();
    },
    passport.authenticate('facebook'),
    function(){}
    // The request will be redirected to Facebook for authentication, so this
    // function will not be called.
);

app.get('/auth/facebook/callback',
    passport.authenticate('facebook', { failureRedirect: '/login' }),
    function(req, res) {
        var callbackURL = req.session.redirectUrl;
        if (!callbackURL) {
            callbackURL = '/';
        }
        res.redirect(callbackURL);
    }
);

app.get('/logout', function(req, res){
    req.logout();
    res.redirect('/');
});

app.use('/api', require('./app/api'));
app.use(require('./app/ui'));

app.use(function (req, res) {
    res.send(404);
});

/*jshint unused:false */
app.use(function (err, req, res, next) {
    res.send(500, {
        err: err.stack
    });
});
/*jshint unused:true */
module.exports = app;
