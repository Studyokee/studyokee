'use strict';

var mongoose = require('mongoose');
var q = require('q');

var User;

var userSchema = mongoose.Schema({
    facebookId: {
        type: String,
        unique: true,
        required: true
    },
    photo: String,
    displayName: String,
    firstName: String
});

function findOne (query) {
    var findOneRequest = q.defer();
    User.findOne(query, findOneRequest.makeNodeResolver());
    return findOneRequest.promise;
}

function save (saveObj) {
    var user = new User(saveObj);
    var saveRequest = q.defer();
    user.save(saveRequest.makeNodeResolver());
    return saveRequest.promise.spread(function(res) {
        return res;
    });
}

userSchema.static('findOrCreate', function (fields) {
    console.log('findOrCreate');
    if (!fields.facebookId) {
        return q.reject('No facebook id provided');
    }

    return findOne({ facebookId: fields.facebookId }).then(function (user) {
        if (user) {
            console.log('found user: ' + JSON.stringify(user));
            return user;
        }
        
        console.log('failed to find user with facebook id, creating new one...');
        return save({ facebookId: fields.facebookId }).fail(function() {
            // Save failed, try to get again in case concurrent request caused failure
            return findOne({ facebookId: fields.facebookId });
        });
    });
});
    
User = mongoose.model('User', userSchema);
module.exports = User;