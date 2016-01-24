'use strict';

var Vocabulary = require('../../../models/vocabulary');
var Word = require('../../../models/word');

var q = require('q');
var express = require('express');
var app = express();


// curl -H 'Content-Type: application/json' -X GET http://localhost:3000/api/vocabulary/5406262930df1d0000000003/es/en
app.get('/:userId/:fromLanguage/:toLanguage', function (req, res) {
    q.resolve().then(function () {
        return Vocabulary.findOrCreate({userId: req.params.userId,
            fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage});
    }).then(function (vocabulary) {
        res.json(200, vocabulary);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});
// curl -H 'Content-Type: application/json' -X PUT -d '{"wordOrPhrase":"test"}' http://localhost:3000/api/vocabulary/5423ae3aca15c0d114000004/remove
app.put('/:userId/:fromLanguage/:toLanguage/remove', function (req, res) {
    q.resolve().then(function () {
        return Vocabulary.removeWord(req.params, req.body.word);
    }).then(function (vocabulary) {
        res.json(200, vocabulary);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});
// curl -H 'Content-Type: application/json' -X PUT -d '{"wordOrPhrase":"test", "definition":"test2"}' http://localhost:3000/api/vocabulary/5406262930df1d0000000003/es/en/add
app.put('/:userId/:fromLanguage/:toLanguage/add', function (req, res) {
    q.resolve().then(function () {
        if (!req.body.word) {
            return q.reject('No word provided');
        }

        return Vocabulary.addWord(req.params, req.body.word);
    }).then(function (vocabulary) {
        res.json(200, vocabulary);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.put('/:userId/:fromLanguage/:toLanguage/import', function (req, res) {
    // Get vocabulary
    // Get dictionary results for words
    // Create vocabulary and dictionary maps

    var vocabulary, dictionary, wordsNotInDictionary, wordsLowerCase;
    q.resolve().then(function () {
        if (!req.body.words) {
            return q.reject('No words provided');
        }

        return Vocabulary.findOrCreate({userId: req.params.userId,
            fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage});
    }).then(function (result) {
        vocabulary = result;

        var words = req.body.words;
        wordsLowerCase = [];
        for (var i = 0; i < words.length; i++) {
            wordsLowerCase.push(words[i].toLowerCase());
        }

        return Word.find({ word: { '$in': wordsLowerCase },
            fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage});
    }).then(function (result) {
        dictionary = result;

        var vocabularyMap = {};
        for (var i = 0; i < vocabulary.words.length; i++) {
            vocabularyMap[vocabulary.words[i].word] = 1;
        }

        var dictionaryMap = {};
        for (var k = 0; k < dictionary.length; k++) {
            dictionaryMap[dictionary[k].word] = dictionary[k];
        }

        var words = wordsLowerCase;
        var wordsToAdd = [];
        wordsNotInDictionary = [];
        for (var j = 0; j < words.length; j++) {
            var word = words[j];
            if (dictionaryMap[word]) {
                if (!vocabularyMap[word]) {
                    wordsToAdd.push(dictionaryMap[word]);
                }
            } else {
                wordsNotInDictionary.push(word);
            }
        }
        console.log('attempting to insert ' + wordsToAdd.length + ' new words: ' + JSON.stringify(wordsToAdd, null, 4));
        console.log('words not in dictionary ' + wordsNotInDictionary.length + ' words: ' + JSON.stringify(wordsNotInDictionary, null, 4));
        
        return Vocabulary.addWords(req.params, wordsToAdd);
    }).then(function (updatedVocabulary) {
        var toReturn = {
            vocabulary: updatedVocabulary,
            wordsNotInDictionary: wordsNotInDictionary
        };
        res.json(200, toReturn);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.put('/:userId/:fromLanguage/:toLanguage/addNext', function (req, res) {
    var vocabulary, dictionary;
    q.resolve().then(function () {
        if (!req.body.quantity) {
            return q.reject('No quantity provided');
        }

        return Vocabulary.findOrCreate({userId: req.params.userId,
            fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage});
    }).then(function (result) {
        vocabulary = result;

        return Word.find({fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage});
    }).then(function (result) {
        dictionary = result;

        var orderedDictionary = [];
        var overflow = [];
        for (var k = 0; k < dictionary.length; k++) {
            var item = dictionary[k];
            var rank = parseInt(item.rank, 10);
            if (rank <= 5000) {
                orderedDictionary.push(item);
                if (rank <= 30) {
                    console.log('word: ' + JSON.stringify(item));
                }
            } else {
                overflow.push(item);
            }
        }
        orderedDictionary.concat(overflow);

        var vocabularyMap = {};
        for (var i = 0; i < vocabulary.words.length; i++) {
            vocabularyMap[vocabulary.words[i].word + '&' + vocabulary.words[i].part] = 1;
        }

        var wordsToAdd = [];
        for (var j = 0; j < orderedDictionary.length; j++) {
            if (wordsToAdd.length >= req.body.quantity) {
                break;
            }

            var entry = orderedDictionary[j];
            if (!vocabularyMap[entry.word + '&' + entry.part]) {
                wordsToAdd.push(entry);
                console.log('GOOD: ' + entry.word + ', ' + entry.part);
            } else {
                console.log('PROBLEM: ' + entry.word + ', ' + entry.part);
            }
        }

        //console.log('attempting to insert ' + wordsToAdd.length + ' new words: ' + JSON.stringify(wordsToAdd));
        
        return Vocabulary.addWords(req.params, wordsToAdd);
    }).then(function (vocabulary) {
        res.json(200, vocabulary);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;