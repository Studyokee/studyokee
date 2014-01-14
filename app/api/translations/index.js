'use strict';

var express = require('express');
var app = express();
var q = require('q');
var request = require('request');

app.get('/:fromLanguage/:toLanguage/:query', function (req, res) {
    
    q.resolve().then(function () {
        var getTranslationRequest = q.defer();

        var query = req.params.query;
        var fromLanguage = req.params.fromLanguage;
        var toLanguage = req.params.toLanguage;
        var url = 'http://yabla.com/player_service.php?action=lookup';
        url += '&word_lang_id=' + fromLanguage;
        url += '&output_lang_id=' + toLanguage;
        url += '&word=' + query;
        console.log('url: ' + url);

        request(url, getTranslationRequest.makeNodeResolver());

        return getTranslationRequest.promise;
    }).spread(function (result, body) {
        var dictionaryMarkup = JSON.parse(body).text;
        res.json(200, dictionaryMarkup);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;