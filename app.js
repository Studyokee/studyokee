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

// Initialize Passport!  Also use passport.session() middleware, to support
// persistent login sessions (recommended).
app.use(passport.initialize());
app.use(passport.session());

// Use the FacebookStrategy within Passport.
//   Strategies in Passport require a `verify` function, which accept
//   credentials (in this case, an accessToken, refreshToken, and Facebook
//   profile), and invoke a callback with a user object.
passport.use(new FacebookStrategy({
        clientID: process.env.FACEBOOK_APP_ID,
        clientSecret: process.env.FACEBOOK_APP_SECRET,
        callbackURL: process.env.URL + '/auth/facebook/callback',
        profileFields: ['id', 'displayName', 'photos', 'name']
    },
    function(accessToken, refreshToken, profile, done) {
        console.log('profile: ' + JSON.stringify(profile, null, 4));
        console.log('find or create user: ' + profile.id);
        User.findOrCreate({ facebookId: profile.id }).then(function (user) {
            console.log('returned from find or create user: ' + JSON.stringify(user));
            var photo = '';
            if (profile.photos && profile.photos.length > 0) {
                photo = profile.photos[0].value;
            }
            var displayName = profile.displayName;
            var firstName = profile.name.givenName;

            console.log('update user with photo: ' + photo);
            console.log('update user with displayName: ' + displayName);
            console.log('update user with firstName: ' + firstName);

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

// Passport session setup.
//   To support persistent login sessions, Passport needs to be able to
//   serialize users into and deserialize users out of the session.  Typically,
//   this will be as simple as storing the user ID when serializing, and finding
//   the user by ID when deserializing.  However, since this example does not
//   have a database of user records, the complete Facebook profile is serialized
//   and deserialized.
passport.serializeUser(function(user, done) {
    console.log('serialiaze user: ' + JSON.stringify(user));
    done(null, user);
});

passport.deserializeUser(function(user, done) {
    console.log('deserialiaze user: ' + JSON.stringify(user));
    //returns a q promise
    done(null, user);
    /*User.findOne({_id: userId}).then(function (user) {
        if (!user) {
            return done(null, null);
        }
        console.log('deserialiaze return user: ' + JSON.stringify(user));
        done(null, user);
    });*/
});

// GET /auth/facebook
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  The first step in Facebook authentication will involve
//   redirecting the user to facebook.com.  After authorization, Facebook will
//   redirect the user back to this application at /auth/facebook/callback
app.get('/auth/facebook',
    passport.authenticate('facebook'),
    function(){}
    // The request will be redirected to Facebook for authentication, so this
    // function will not be called.
);

// GET /auth/facebook/callback
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  If authentication fails, the user will be redirected back to the
//   login page.  Otherwise, the primary route function function will be called,
//   which, in this example, will redirect the user to the home page.
app.get('/auth/facebook/callback',
    passport.authenticate('facebook', { failureRedirect: '/login' }),
    function(req, res) {
        res.redirect('/');
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
