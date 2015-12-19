'use strict';

var express = require('express');
var app = express();
var q = require('q');
var request = require('request');

// Merriam-Webster Spanish define code
var Dictionary = require('./mw-dictionary');
var dict = new Dictionary({
    key: process.env.WM_DICTIONARY_API_KEY,
    url: 'http://www.dictionaryapi.com/api/v1/references/spanish/xml/'
});

function getSpanishDefinition (word) {
    return q.resolve().then(function () {
        console.log('Merriam Webster dictionary used: ' + word);
        var defineRequest = q.defer();
        dict.define(word, defineRequest.makeNodeResolver());

        return defineRequest.promise;
    }).then(function (result) {
        var toReturn = {
            type: 'mw',
            result: result
        };
        return toReturn;
    });
}

// General use definition using Google
function getDefinition (query, fromLanguage, toLanguage) {
    return q.resolve().then(function () {
        console.log('Google translate used' + query);
        var getTranslationRequest = q.defer();
        var url = '';
        //if (query.indexOf(' ') > 0) {
        url = 'https://www.googleapis.com/language/translate/v2?';
        url += 'key=' + process.env.GOOGLE_API_KEY;
        url += '&q=' + encodeURIComponent(query);
        url += '&source=' + fromLanguage;
        url += '&target=' + toLanguage;
        url += '&format=text';
        // } else {
        //     url = 'http://api.wordreference.com/' + process.env.WORD_REFERENCE_API_KEY + '/json/';
        //     url += fromLanguage;
        //     url += toLanguage;
        //     url += '/' + encodeURIComponent(query);
        // }

        console.log('url: ' + url);
        request(url, getTranslationRequest.makeNodeResolver());

        return getTranslationRequest.promise;
    }).spread(function (result, body) {
        var toReturn = {
            type: 'google',
            result: body
        };
        return toReturn;
    });
}

app.get('/', function (req, res) {
    q.resolve().then(function () {

        var query = req.query.query;
        var fromLanguage = req.query.fromLanguage;
        var toLanguage = req.query.toLanguage;

        if (fromLanguage === 'es' && toLanguage === 'en' && query && (query.indexOf(' ') < 0)) {
            // use Merriam-Webster for single Spanish words
            return getSpanishDefinition(query);
        } else {
            return getDefinition(query, fromLanguage, toLanguage);
        }
    }).then(function (result) {
        res.json(200, result);
    }).fail(function (err) {
        console.log('Dictionary Error: ' + err);
        res.json(500, {
            err: err
        });
    });
});

/*
$.ajax( { 
  url: '//api.wordreference.com/3b126/json/pten/Assim', 
  type: 'POST', 
  dataType: 'jsonp',
  success: function(result) {
    console.log(result);
  }
});
*/

module.exports = app;