'use strict';

var express = require('express');
var q = require('q');
var app = express();
var assert = require('assert');
var utilities = require('../../../utilities');

app.get('/:id/translations/:language', function (req, res) {
    q.resolve().then(function () {
        assert(req.hasOwnProperty('song'));
        assert(req.params.hasOwnProperty('language'));

        var toLanguage = req.params.language;
        var song = req.song;
        return song.getTranslation(toLanguage);
    }).then(function (translation) {
        res.send(200, translation);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.put('/:id/translations/:language', utilities.ensureAuthenticated, utilities.ensureAdmin, function (req, res) {
    q.resolve().then(function () {
        assert(req.hasOwnProperty('song'));
        assert(req.params.hasOwnProperty('language'));
        assert(req.body.hasOwnProperty('translation'));
        
        var toLanguage = req.params.language;
        var song = req.song;
        var translation = req.body.translation;
        var translations = song.translations;

        var updatedTranslations = [];
        for (var i = 0; i < translations.length; i++) {
            if (translations[i].language !== toLanguage) {
                updatedTranslations.push(translations[i]);
            }
        }

        updatedTranslations.push({
            language: toLanguage,
            data: translation
        });

        var updates = {
            translations: updatedTranslations
        };

        var updateRequest = q.defer();
        song.update(updates, updateRequest.makeNodeResolver());

        return updateRequest;
    }).then(function () {
        res.send(200);
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

module.exports = app;