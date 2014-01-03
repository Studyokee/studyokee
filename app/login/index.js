'use strict';

var express = require('express'),
    passport = require('passport'),
    RdioStrategy = require('passport-rdio').Strategy;
var User = require('../../models/user');
var q = require('q');

// Passport session setup.
// ßTo support persistent login sessions, Passport needs to be able to
// ßserialize users into and deserialize users out of the session.  Typically,
// ßthis will be as simple as storing the user ID when serializing, and finding
// ßthe user by ID when deserializing.  However, since this example does not
// ßhave a database of user records, the complete Rdio profile is
// ßserialized and deserialized.
passport.serializeUser(function(user, done) {
    done(null, user);
});

passport.deserializeUser(function(obj, done) {
    done(null, obj);
});

// Use the RdioStrategy within Passport.
//   Strategies in passport require a `verify` function, which accept
//   credentials (in this case, a token, tokenSecret, and Rdio profile), and
//   invoke a callback with a user object.
passport.use(new RdioStrategy({
    consumerKey: process.env.RDIO_API_KEY,
    consumerSecret: process.env.RDIO_SHARED_SECRET,
    callbackURL: process.env.URL + '/auth/rdio/callback'
}, function(token, tokenSecret, profile, done) {
    console.log('profile: ' + JSON.stringify(profile, null, 4));

    q.resolve().then(function () {
        return User.getByRdioId(profile.id);
    }).then(function (user) {
        var updates = {
            oauth: {
                token: token,
                tokenSecret: tokenSecret
            }
        };
        var updateRequest = q.defer();
        user.update(updates, updateRequest.makeNodeResolver());
        return updateRequest.promise;
    }).then(function () {
        done(null, profile);
    }).fail(function (err) {
        console.log('Error: ' + err);
        done(null, profile);
    });
    // // asynchronous verification, for effect...
    // process.nextTick(function () {
      
    //   // To keep the example simple, the user's Rdio profile is returned to
    //   // represent the logged-in user.  In a typical application, you would want
    //   // to associate the Rdio account with a user record in your database,
    //   // and return that user instead.
    //     return done(null, profile);
    // });
}));

var app = express();

// configure Express
app.configure(function() {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'ejs');
    // Initialize Passport!  Also use passport.session() middleware, to support
    // persistent login sessions (recommended).
    app.use(passport.initialize());
    app.use(passport.session());
    app.use(app.router);
});

app.get('/auth/rdio',
  passport.authenticate('rdio')
);

app.get('/auth/rdio/fail',
    function(req, res) {
        res.redirect('authfail');
    }
);

app.get('/auth/rdio/callback',
  passport.authenticate('rdio', {
    successRedirect: '/',
    failureRedirect: '/auth/rdio/fail'
})
);

app.get('/logout', function(req, res){
    req.logout();
    res.redirect('/');
});

module.exports = app;