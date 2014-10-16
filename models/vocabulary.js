'use strict';

var mongoose = require('mongoose');
var q = require('q');

var Vocabulary;

var vocabularySchema = mongoose.Schema({
    userId: {
        type: String,
        required: true
    },
    fromLanguage: {
        type: String,
        required: true
    },
    toLanguage: {
        type: String,
        required: true
    },
    words: [{
        wordOrPhrase: String,
        definition: Object
    }]
});

function findOne (query) {
    var findOneRequest = q.defer();
    Vocabulary.findOne(query, findOneRequest.makeNodeResolver());
    return findOneRequest.promise;
}

function save (saveObj) {
    var vocabulary = new Vocabulary(saveObj);
    var saveRequest = q.defer();
    vocabulary.save(saveRequest.makeNodeResolver());
    return saveRequest.promise.spread(function(res) {
        return res;
    });
}

function getIndex (words, wordOrPhrase) {
    for (var i = 0; i < words.length; i++) {
        if (words[i].wordOrPhrase === wordOrPhrase) {
            return i;
        }
    }
    return -1;
}

vocabularySchema.static('addWordOrPhrase', function(query, wordOrPhrase, definition) {
    return q.resolve().then(function () {
        return Vocabulary.findOrCreate(query);
    }).then(function (vocabulary) {
        if (getIndex(vocabulary.words, wordOrPhrase) === -1) {
            vocabulary.words.push({wordOrPhrase: wordOrPhrase, definition: definition});

            var updates = {
                words: vocabulary.words
            };

            var updateRequest = q.defer();
            vocabulary.update(updates, updateRequest.makeNodeResolver());

            return updateRequest;
        }
        return;
    });
});

vocabularySchema.static('removeWordOrPhrase', function(query, wordOrPhrase) {
    return q.resolve().then(function () {
        return Vocabulary.findOrCreate(query);
    }).then(function (vocabulary) {
        var i = getIndex(vocabulary.words, wordOrPhrase);
        vocabulary.words.splice(i, 1);

        var updates = {
            words: vocabulary.words
        };

        var updateRequest = q.defer();
        vocabulary.update(updates, updateRequest.makeNodeResolver());

        return updateRequest;
    });
});

vocabularySchema.static('findOrCreate', function (fields) {
    if (!fields.userId) {
        return q.reject('No user id provided');
    }
    if (!fields.fromLanguage) {
        return q.reject('No from language provided');
    }
    if (!fields.toLanguage) {
        return q.reject('No to language provided');
    }

    return findOne({ userId: fields.userId, fromLanguage: fields.fromLanguage, toLanguage: fields.toLanguage }).then(function (vocabulary) {
        if (vocabulary) {
            console.log('found vocabulary: ' + JSON.stringify(vocabulary));
            return vocabulary;
        }
        
        console.log('failed to find vocabulary matching criteria, creating new one...');
        return save({ userId: fields.userId, fromLanguage: fields.fromLanguage, toLanguage: fields.toLanguage }).fail(function() {
            // Save failed, try to get again in case concurrent request caused failure
            return findOne({ userId: fields.userId, fromLanguage: fields.fromLanguage, toLanguage: fields.toLanguage });
        });
    });
});
    
Vocabulary = mongoose.model('Vocabulary', vocabularySchema);
module.exports = Vocabulary;