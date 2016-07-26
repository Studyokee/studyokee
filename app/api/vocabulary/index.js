'use strict';

var Vocabulary = require('../../../models/vocabulary');

var q = require('q');
var express = require('express');
var app = express();
var utilities = require('../utilities');


// curl -H 'Content-Type: application/json' -X GET http://localhost:3000/api/vocabulary/es/en
app.get('/:fromLanguage/:toLanguage', function (req, res) {
    q.resolve().then(function () {
        return Vocabulary.findOrCreate({userId: req.user._id,
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
// curl -H 'Content-Type: application/json' -X PUT -d '{"wordOrPhrase":"test"}' http://localhost:3000/api/vocabulary/es/en/remove
app.put('/:fromLanguage/:toLanguage/remove', utilities.ensureAuthenticated, function (req, res) {
    q.resolve().then(function () {
        if (req.user._id) {
            req.params.userId = req.user._id;
        }

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
// curl -H 'Content-Type: application/json' -X PUT -d '{"wordOrPhrase":"test", "definition":"test2"}' http://localhost:3000/api/vocabulary/es/en/add
app.put('/:fromLanguage/:toLanguage/add', utilities.ensureAuthenticated, function (req, res) {
    q.resolve().then(function () {
        if (!req.body.word) {
            return q.reject('No word provided');
        }
        if (req.user._id) {
            req.params.userId = req.user._id;
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

module.exports = app;