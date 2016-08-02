'use strict';

var express = require('express');
var app = express();
var q = require('q');

var Word = require('../../../models/word');
var endings = ['a','o','as','os','es'];
var utilities = require('../utilities');

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

        console.log('Looking for word: ' + req.query.word.toLowerCase());
        return Word.find({word: req.query.word.toLowerCase(),
            fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage});
    }).then(function (words) {
        // check stem if we found nothing
        var str = req.query.word.toLowerCase();
        if (words && words.length ===0 && str.length > 2) {
            for (var i = 0; i < endings.length; i++) {
                var suffix = endings[i];
                // ends with ending
                var start = str.indexOf(suffix, str.length - suffix.length);
                if (start !== -1) {
                    console.log('Looking for word with stem match: ' + str.substr(0, start));
                    return Word.find({stem: str.substr(0, start),
                        fromLanguage: req.params.fromLanguage,
                        toLanguage: req.params.toLanguage});
                }
            }
        }
        return q.resolve(words);
    }).then(function (words) {
        res.json(200, words);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.get('/:fromLanguage/:toLanguage/index', function (req, res) {
    q.resolve().then(function () {
        if (!req.params.fromLanguage) {
            return q.reject('No from language provided');
        }
        if (!req.params.toLanguage) {
            return q.reject('No to language provided');
        }

        return Word.find({fromLanguage: req.params.fromLanguage,
            toLanguage: req.params.toLanguage}, 'word stem rank part');
    }).then(function (words) {
        res.json(200, words);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.post('/add', utilities.ensureAuthenticated, utilities.ensureAdmin, function (req, res) {
    q.resolve().then(function () {
        var words = req.body.words;
        return Word.create(words);
    }).then(function (words) {
        res.json(200, words);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});


module.exports = app;