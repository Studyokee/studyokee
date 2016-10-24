'use strict';

var Utilities = {};

Utilities.ensureAuthenticated = function(req, res, next) {
    if (req.isAuthenticated()) { return next(); }
    res.json(500, {
        err: 'User is not logged in or does not have permission to do this action'
    });
};

Utilities.ensureAdmin = function (req, res, next) {
    /*if (req.user.admin === true) { return next(); }
    res.json(500, {
        err: 'This action requires admin access'
    });*/
    return next();
};

module.exports = Utilities;