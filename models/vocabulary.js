'use strict';

var mongoose = require('mongoose');
var q = require('q');
var Word = require('./word');

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
        wordId: mongoose.Schema.Types.ObjectId,
        word: String,
        known: Boolean
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

function getIndex (words, wordId) {
    for (var i = 0; i < words.length; i++) {
        if (words[i].wordId.toString() === wordId.toString()) {
            return i;
        }
    }
    return -1;
}

vocabularySchema.static('addWord', function(query, word) {
    return q.resolve().then(function () {
        return Vocabulary.findOrCreate(query);
    }).then(function (vocabulary) {
        if (getIndex(vocabulary.words, word._id) === -1) {
            return Vocabulary.addWords(query, [word]);
        }

        return q.resolve();
    });
});

vocabularySchema.static('addWords', function(query, words) {
    var toReturn = null;
    return q.resolve().then(function () {
        return Vocabulary.findOrCreate(query);
    }).then(function (vocabulary) {
        toReturn = vocabulary;
        for (var i = 0; i < words.length; i++) {
            if (vocabulary.words.length < process.env.VOCABULARY_LIMIT) {
                var word = words[i];
                var toInsert = {
                    wordId: word._id,
                    word: word.word,
                    known: false
                };
                vocabulary.words.push(toInsert);
            }
        }
        
        var updates = {
            words: vocabulary.words
        };

        var updateRequest = q.defer();
        vocabulary.update(updates, updateRequest.makeNodeResolver());

        return updateRequest.promise;
    }).then(function () {
        return toReturn;
    });
});

vocabularySchema.static('removeWord', function(query, word) {
    var toReturn = null;
    var i;
    return q.resolve().then(function () {
        return Vocabulary.findOrCreate(query);
    }).then(function (vocabulary) {
        toReturn = vocabulary;
        i = getIndex(vocabulary.words, word.wordId);
        vocabulary.words[i].known = true;
        console.log('marking word: ' + vocabulary.words[i].word + ' as known');
        console.log('now: ' + vocabulary.words[i].known);

        var updates = {
            words: vocabulary.words
        };

        var updateRequest = q.defer();
        vocabulary.update(updates, updateRequest.makeNodeResolver());

        return updateRequest.promise;
    }).then(function () {
        console.log('tmarking word: ' + toReturn.words[i].word + ' as known');
        console.log('tnow: ' + toReturn.words[i].known);
        return toReturn;
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
            return vocabulary;
        }
        
        console.log('failed to find vocabulary matching criteria, creating new one...');
        return save({ userId: fields.userId, fromLanguage: fields.fromLanguage, toLanguage: fields.toLanguage }).fail(function() {
            // Save failed, try to get again in case concurrent request caused failure
            return findOne({ userId: fields.userId, fromLanguage: fields.fromLanguage, toLanguage: fields.toLanguage });
        });
    });
});


vocabularySchema.static('fillWords', function (vocabulary) {
    if (!vocabulary.words) {
        return q.resolve().then(function () {
            return vocabulary;
        });
    }

    return q.resolve().then(function () {
        // Match words to words in dictionary
        var wordIds = vocabulary.words.map(function(word) {
            return word.wordId;
        });
        
        var findOneRequest = q.defer();
        var query = {
            '_id': { $in: wordIds }
        };
        Word.find(query, findOneRequest.makeNodeResolver());
        return findOneRequest.promise;
    }).then(function (dictionaryWords) {
        // Create map of dictionary lookups
        var dictionaryWordsMap = {};
        for (var j = 0; j < dictionaryWords.length; j++) {
            dictionaryWordsMap[dictionaryWords[j]._id.toString()] = dictionaryWords[j];
        }

        for (var i = 0; i < vocabulary.words.length; i++) {
            var wordWithInfo = vocabulary.words[i];

            // Get dictionary
            var dictionaryWord = dictionaryWordsMap[wordWithInfo.wordId.toString()];
            if (dictionaryWord) {
                wordWithInfo.stem = dictionaryWord.stem;
                wordWithInfo.def = dictionaryWord.def;
                wordWithInfo.example = dictionaryWord.example;
                wordWithInfo.rank = dictionaryWord.rank;
                wordWithInfo.part = dictionaryWord.part;
            }
        }
        return vocabulary;
    });
});

Vocabulary = mongoose.model('Vocabulary', vocabularySchema);
module.exports = Vocabulary;