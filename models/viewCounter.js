'use strict';

var mongoose = require('mongoose');
var q = require('q');
var assert = require('assert');

var ViewCounter;

var viewCounterSchema = mongoose.Schema({
    fromLanguage: {
        type: String,
        required: true
    },
    toLanguage: {
        type: String,
        required: true
    },
    rdioKey: {
        type: String,
        unique: true
    },
    viewCount: Number
});

viewCounterSchema.static('logView', function(fromLanguage, toLanguage, rdioKey) {
    console.log('Log view: from: ' + fromLanguage + ' to: ' + toLanguage + ' with key: ' + rdioKey);
    return ViewCounter.getViewCounter(fromLanguage, toLanguage, rdioKey).then(function (viewCounter) {
        var updates = {
            viewCount: viewCounter.viewCount + 1
        };

        var updateRequest = q.defer();
        viewCounter.update(updates, updateRequest.makeNodeResolver());
        return updateRequest.promise;
    });
});

viewCounterSchema.static('getTopViewed', function(fromLanguage, toLanguage) {
    console.log('Get top viewed: from: ' + fromLanguage + ' to: ' + toLanguage);
    assert(fromLanguage, 'No fromLanguage provided');
    assert(toLanguage, 'No toLanguage provided');

    var findRequest = q.defer();
    ViewCounter.find({
        fromLanguage: fromLanguage,
        toLanguage: toLanguage
    }, null, {
        sort: {
            viewCount: -1
        }
    },findRequest.makeNodeResolver());

    return findRequest.promise.then(function (viewCounters) {
        return viewCounters;
    });
});

viewCounterSchema.static('getViewCounter', function(fromLanguage, toLanguage, rdioKey) {
    assert(fromLanguage, 'No fromLanguage provided');
    assert(toLanguage, 'No toLanguage provided');
    assert(rdioKey, 'No Rdio key provided');

    return q.resolve().then(function () {
        var findRequest = q.defer();
        ViewCounter.findOne({
            fromLanguage: fromLanguage,
            toLanguage: toLanguage,
            rdioKey: rdioKey
        }, findRequest.makeNodeResolver());

        return findRequest.promise;
    }).then(function (viewCounter) {
        if (viewCounter) {
            return viewCounter;
        }

        console.log('failed to find viewCounter, creating new one...');
        viewCounter = new ViewCounter({
            fromLanguage: fromLanguage,
            toLanguage: toLanguage,
            rdioKey: rdioKey,
            viewCount: 0
        });
        var saveRequest = q.defer();
        viewCounter.save(saveRequest.makeNodeResolver());
        return saveRequest.promise.spread(function(res) {
            return q.resolve(res);
        }).fail(function() {
            var findRetryRequest = q.defer();
            ViewCounter.findOne({
                fromLanguage: fromLanguage,
                toLanguage: toLanguage,
                rdioKey: rdioKey
            }, findRetryRequest.makeNodeResolver());
            return findRetryRequest.promise;
        });
    }).fail(function (err) {
        console.log('err: '+ err);
    });
});

ViewCounter = mongoose.model('ViewCounter', viewCounterSchema);
module.exports = ViewCounter;