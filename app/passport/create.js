'use strict';

var CreateStrategy   = require('passport-create').Strategy;
var User = require('../../models/user');

module.exports = function(passport){
    passport.use(new CreateStrategy({
            passReqToCallback : true
        },
        function(req, done) {
            User.count({}, function(err, c) {
                if (c < process.env.USER_LIMIT) {
                    User.create({ username: 't' + new Date().getTime(), displayName: 'User', language: req.query.language }, function (err, user) {
                        if (err) { return done(err); }
                        if (!user) { return done(null, false); }
                        return done(null, user);
                    });
                } else {
                    var error = 'User signup limit reached: ' + c;
                    console.log(error);
                    return done(error);
                }
            });
        }
    ));
};