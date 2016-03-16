'use strict';

var CreateStrategy   = require('passport-create').Strategy;
var User = require('../../models/user');

module.exports = function(passport){
    passport.use(new CreateStrategy(
        function(done) {
            User.create({ username: 't' + new Date().getTime() }, function (err, user) {
                if (err) { return done(err); }
                if (!user) { return done(null, false); }
                return done(null, user);
            });
        }
    ));
};