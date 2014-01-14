'use strict';

var mongoose = require('mongoose');
var assert = require('assert');
var q = require('q');

var Suggestions;

var suggestionsSchema = mongoose.Schema({
    fromLanguage: {
        type: String,
        required: true
    },
    toLanguage: {
        type: String,
        required: true
    },
    songs: [String]
});

suggestionsSchema.static('getSuggestions', function(fromLanguage, toLanguage) {
    assert(fromLanguage, 'No fromLanguage provided');
    assert(toLanguage, 'No toLanguage provided');

    return q.resolve().then(function () {
        var findRequest = q.defer();
        Suggestions.findOne({
            fromLanguage: fromLanguage,
            toLanguage: toLanguage
        }, findRequest.makeNodeResolver());

        return findRequest.promise;
    }).then(function (suggestions) {
        if (suggestions) {
            return suggestions;
        }

        console.log('failed to find suggestions object, creating new one...');
        suggestions = new Suggestions({
            fromLanguage: fromLanguage,
            toLanguage: toLanguage,
            songs: []
        });
        var saveRequest = q.defer();
        suggestions.save(saveRequest.makeNodeResolver());
        return saveRequest.promise.spread(function(res) {
            return q.resolve(res);
        }).fail(function() {
            var findRetryRequest = q.defer();
            Suggestions.findOne({
                fromLanguage: fromLanguage,
                toLanguage: toLanguage
            }, findRetryRequest.makeNodeResolver());
            return findRetryRequest.promise;
        });
    }).fail(function (err) {
        console.log('err: '+ err);
    });
});

Suggestions = mongoose.model('Suggestions', suggestionsSchema);
module.exports = Suggestions;