'use strict';

var mongoose = require('mongoose');
//var q = require('q');

var User;

var userSchema = mongoose.Schema({
    username: { type : String , unique : true, required : true },
    displayName: String,
    password: String,
    admin: { type : Boolean, default: false}
});

/*function findOne (query) {
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
}*/
    
User = mongoose.model('User', userSchema);
module.exports = User;