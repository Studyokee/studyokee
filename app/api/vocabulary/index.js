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

        // go through dictionary checking against vocab map until quantity found
        var vocabularyMap = {};
        for (var i = 0; i < vocabulary.words.length; i++) {
            vocabularyMap[vocabulary.words[i].word] = 1;
        }

        var wordsToAdd = [];
        for (var j = 0; j < dictionary.length; j++) {
            if (wordsToAdd.length >= req.body.quantity) {
                break;
            }

            if (!vocabularyMap[dictionary[j].word]) {
                wordsToAdd.push(dictionary[j]);
            }
        }

        console.log('attempting to insert ' + wordsToAdd.length + ' new words');
        
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