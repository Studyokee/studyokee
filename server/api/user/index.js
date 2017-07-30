'use strict';

var q = require('q');
var User = require('../../../models/user');
var bCrypt = require('bcrypt-nodejs');
var express = require('express');
var app = express();
var utilities = require('../utilities');

// Generates hash using bCrypt
var createHash = function(password){
    return bCrypt.hashSync(password);
};

app.put('/', utilities.ensureAuthenticated, function (req, res) {
    q.resolve().then(function () {
        // get current user
        var currentUserInfo = req.user;
        var newUserInfo = {};
        if (req.body.password) {
            newUserInfo.password = createHash(req.body.password);
        }
        if (req.body.displayName) {
            newUserInfo.displayName = req.body.displayName;
        }
        if (req.body.username) {
            newUserInfo.username = req.body.username;
        }

        var updates = {
            '$set': newUserInfo
        };
        console.log('update user: ' + JSON.stringify(updates));
        var updateRequest = q.defer();
        User.update({_id: currentUserInfo._id}, updates, {}, updateRequest.makeNodeResolver());
        return updateRequest;
    }).then(function (user) {
        res.send(200, user);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;