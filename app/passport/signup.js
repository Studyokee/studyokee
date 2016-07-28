'use strict';

var bCrypt = require('bcrypt-nodejs');
var LocalStrategy   = require('passport-local').Strategy;
var User = require('../../models/user');

module.exports = function(passport){

    passport.use('signup', new LocalStrategy({
            passReqToCallback : true,
            failureFlash: true // optional, see text as well
        },
        function(req, username, password, done) {
            var findOrCreateUser = function(){
                // find a user in Mongo with provided username
                User.findOne({'username':username},function(err, user) {
                    // In case of any error return
                    if (err){
                        console.log('Error in SignUp: '+err);
                        return done(err);
                    }
                    // already exists
                    if (user) {
                        console.log('User already exists');
                        return done(null, false, req.flash('message', 'User Already Exists'));
                    } else {
                        User.count({}, function(err, c) {
                            if (c < process.env.USER_LIMIT) {
                                // if there is no user with that email
                                // create the user
                                var newUser = new User();
                                // set the user's local credentials
                                newUser.username = username;
                                newUser.password = createHash(password);

                                // save the user
                                newUser.save(function(err) {
                                    if (err){
                                        console.log('Error in Saving user: '+err);
                                        return done(null, false, req.flash('message', err));
                                    }
                                    console.log('User Registration succesful');
                                    return done(null, newUser);
                                });
                            } else {
                                var error = 'User signup limit reached: ' + c;
                                console.log(error);
                                return done(error);
                            }
                        });
                    }
                });
            };
             
            // Delay the execution of findOrCreate and execute 
            // the method in the next tick of the event loop
            process.nextTick(findOrCreateUser);
        })
    );

    // Generates hash using bCrypt
    var createHash = function(password){
        return bCrypt.hashSync(password, bCrypt.genSaltSync(10), null);
    };
};