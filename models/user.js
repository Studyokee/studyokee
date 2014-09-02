'use strict';

var mongoose = require('mongoose');
var q = require('q');

var User;

var userSchema = mongoose.Schema({
    facebookId: {
        type: String,
        unique: true,
        required: true
    }
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
        return q.resolve(res);
    });
}

userSchema.static('findOrCreate', function (fields) {
    if (!fields.facebookId) {
        return q.reject('No facebook id provided');
    }

    return findOne({ facebookId: fields.facebookId }).then(function (user) {
        if (user) {
            return user;
        }
        
        console.log('failed to find facebook id, creating new one...');
        return save({ facebookId: fields.facebookId }).fail(function() {
            // Save failed, try to get again in case concurrent request caused failure
            return findOne({ facebookId: fields.facebookId });
        });
    });
});
    
User = mongoose.model('User', userSchema);
module.exports = User;