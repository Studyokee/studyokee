'use strict';

var express = require('express');
var app = express();
var q = require('q');
var request = require('request');

app.get('/', function (req, res) {
    q.resolve().then(function () {
        var getTranslationRequest = q.defer();

        var query = req.query.query;
        var fromLanguage = req.query.fromLanguage;
        var toLanguage = req.query.toLanguage;

        var url = '';
        if (query.indexOf(' ') > 0) {
            url = 'https://www.googleapis.com/language/translate/v2?';
            url += 'key=' + process.env.GOOGLE_API_KEY;
            url += '&q=' + encodeURIComponent(query);
            url += '&source=' + fromLanguage;
            url += '&target=' + toLanguage;
            url += '&format=text';
        } else {
            url = 'http://api.wordreference.com/' + process.env.WORD_REFERENCE_API_KEY + '/json/';
            url += fromLanguage;
            url += toLanguage;
            url += '/' + encodeURIComponent(query);
        }

        console.log('url: ' + url);
        request(url, getTranslationRequest.makeNodeResolver());

        return getTranslationRequest.promise;
    }).spread(function (result, body) {
        // var dictionaryMarkup = JSON.parse(body).text;
        res.json(200, JSON.parse(body));
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;