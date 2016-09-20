'use strict';

var express = require('express');
var app = express();
var q = require('q');

var Word = require('../../../models/word');
var utilities = require('../utilities');
var request = require('request');

function getGoogleTranslation(fromLanguage, toLanguage, query) {
    return q.resolve().then(function () {
        var getTranslationRequest = q.defer();
        var url = '';
        url = 'https://www.googleapis.com/language/translate/v2?';
        url += 'key=' + process.env.GOOGLE_API_KEY;
        url += '&q=' + encodeURIComponent(query);
        url += '&source=' + fromLanguage;
        url += '&target=' + toLanguage;
        url += '&format=text';
        console.log('url: ' + url);
        request(url, getTranslationRequest.makeNodeResolver());

        return getTranslationRequest.promise;
    }).spread(function (res, body) {
        console.log('worked!');
        // transform result shape
        var result = JSON.parse(body);
        console.log('result: ' + JSON.stringify(result));
        var def = '';
        if (result && result.data && result.data.translations && result.data.translations.length > 0) {
            def = result.data.translations[0].translatedText;
        }
        var toReturn = {
            word: query,
            stem: query,
            fromLanguage: fromLanguage,
            toLanguage: toLanguage,
            def: def,
            example: '',
            rank: 0,
            part: ''
        };
        return Word.findOrCreate(toReturn);
    }).then(function (word) {
        return word;
    });
}

function getSpanishTranslation(fromLanguage, toLanguage, word) {
    return q.resolve().then(function () {
        return Word.findOne({word: word,
                fromLanguage: fromLanguage,
                toLanguage: toLanguage});
    }).then(function (wordObject) {
        // check stem if we found nothing
        var endings = ['a','o','as','os','es'];
        if (!wordObject && word.length > 2) {
            for (var i = 0; i < endings.length; i++) {
                var suffix = endings[i];
                // ends with ending
                var start = word.indexOf(suffix, word.length - suffix.length);
                if (start !== -1) {
                    console.log('Looking for word with stem match: ' + word.substr(0, start));
                    return Word.findOne({stem: word.substr(0, start),
                        fromLanguage: fromLanguage,
                        toLanguage: toLanguage});
                }
            }
        }
        return q.resolve(null);
    });
}

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

        if (req.params.fromLanguage === 'es') {
            console.log('Using Spanish Dictionary');
            return getSpanishTranslation(req.params.fromLanguage, req.params.toLanguage, req.query.word.toLowerCase());
        }

        console.log('Using Google Translate');
        return getGoogleTranslation(req.params.fromLanguage, req.params.toLanguage, req.query.word.toLowerCase());
    }).then(function (word) {
        res.json(200, word);
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