'use strict';

var mongoose = require('mongoose');
var q = require('q');

var User;

var userSchema = mongoose.Schema({
    rdioId: {
        type: String,
        required: true,
        unique: true
    },
    oauth: {
        token: String,
        tokenSecret: String
    }
});

userSchema.static('getByRdioId', function (rdioId) {
    console.log('find user with rdio id: ' + rdioId);
    var findOneRequest = q.defer();
    User.findOne({
        rdioId: rdioId
    }, findOneRequest.makeNodeResolver());

    return findOneRequest.promise.then(function (user) {
        if (!user) {
            if (rdioId) {
                console.log('failed to find user, creating new one...');
                user = new User({
                    rdioId: rdioId
                });
                var saveRequest = q.defer();
                user.save(saveRequest.makeNodeResolver());
                return saveRequest.promise.spread(function(res) {
                    return q.resolve(res);
                }).fail(function() {
                    var findOneRetryRequest = q.defer();
                    User.findOne({
                        rdioId: rdioId
                    }, findOneRetryRequest.makeNodeResolver());
                    return findOneRetryRequest.promise;
                });
            } else {
                console.log('no rdioId supplied!');
                throw 'no rdioId supplied!';
            }

        }
        console.log('found existing user: ' + user);
        return user;
    });
});

User = mongoose.model('User', userSchema);
module.exports = User;