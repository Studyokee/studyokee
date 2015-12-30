'use strict';

var express = require('express');
var app = express();
var q = require('q');

var Word = require('../../../models/word');

app.get('/:fromLanguage/:toLanguage', function (req, res) {
    q.resolve().then(function () {
        if (!req.query.word) {
            return q.reject('No word provided');
        }
        if (!req.params.fromLanguage) {
            return q.reject('No from language provided');
        }
        if (!req.params.toLanguage) {
            return q.reject('No to language provided');
        }

        return Word.find({word: req.query.word.toLowerCase(),
            fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage});
    }).then(function (words) {
        res.json(200, words);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.post('/add', function (req, res) {
    q.resolve().then(function () {
        var words = req.body.words;

        console.log('test1:' + JSON.stringify(words, null, 4));
        return Word.create(words);
    }).then(function (words) {
        console.log('test2');
        res.json(200, words);
    }).fail(function (err) {
        console.log('test3');
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});


module.exports = app;