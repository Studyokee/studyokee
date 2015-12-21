'use strict';

var Vocabulary = require('../../../models/vocabulary');

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
        return Vocabulary.removeWordOrPhrase(req.params, req.body.wordOrPhrase);
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
        return Vocabulary.addWordOrPhrase(req.params, req.body.wordOrPhrase, req.body.definition);
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