'use strict';

var ViewCounter = require('../../../../models/viewCounter');

var config = {
    rdio_api_key: process.env.RDIO_API_KEY,
    rdio_api_shared: process.env.RDIO_SHARED_SECRET,
    callback_url: '/'
};
var rdio = require('../../rdio/rdio')(config);

var express = require('express');
var app = express();
var q = require('q');

app.get('/:fromLanguage/:toLanguage', function (req, res) {
    q.resolve().then(function () {
        return ViewCounter.getTopViewed(req.params.fromLanguage, req.params.toLanguage);
    }).then(function (topViewed) {
        var rdioKeys = [];
        for (var i = 0; i < topViewed.length; i++) {
            rdioKeys.push(topViewed[i].rdioKey);
        }
        console.log('Get rdio keys: ' + rdioKeys);
        var data = {
            keys: rdioKeys,
            method: 'get'
        };

        var rdioRequest = q.defer();
        rdio.api(null, null, data, rdioRequest.makeNodeResolver());
        return rdioRequest.promise.spread(function (rdioResult) {
            console.log('Retrieved keys from Rdio');
            var parsedResult = JSON.parse(rdioResult);
            if (parsedResult.result) {
                var suggestions = [];
                for (var i = 0; i < topViewed.length; i++) {
                    var rdioKey = topViewed[i].rdioKey;
                    suggestions.push(parsedResult.result[rdioKey]);
                }
                res.json(200, suggestions);
            } else {
                res.json(200, []);
            }
        });
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;