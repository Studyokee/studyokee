'use strict';

var Song = require('../../../../models/song');

var express = require('express');
var q = require('q');
var app = express();
var assert = require('assert');

app.get('/rdio/:rdioKey/:language', function (req, res) {
    assert(req.hasOwnProperty('song'));

    var toLanguage = req.params.language;
    var song = req.song;
    var translation = song.getTranslation(toLanguage);

    if (translation && translation.data) {
        console.log('found existing translation');
        res.json(200, translation.data);
        return;
    }

    q.resolve().then(function () {
        var getSubtitlesRequest = Song.getSubtitles(song.rdioData.artist, song.rdioData.name);

        return getSubtitlesRequest.then(function (subtitles) {
            if (!subtitles || subtitles.length === 0) {
                res.send(404);
                return q.defer().reject('no subtitles');
            }

            console.log('fetched subtitles');
            var getLanguageRequest = q.resolve().then(function () {
                if (song.metadata.language) {
                    return song.metadata.language;
                }
                return Song.getLanguage(subtitles);
            });

            return getLanguageRequest.then(function (language) {
                console.log('fetched language: ' + language);

                if (!language) {
                    res.send(404);
                    return q.defer().reject('no language identified');
                }

                return Song.getDefaultTranslation(subtitles, language, toLanguage).then(function (translation) {
                    console.log('fetched translation');
                    res.json(200, translation);

                    var translations = [];
                    if (song.translations && song.translations.length > 0) {
                        translations = song.translations;
                    }
                    translations.push({
                        language: toLanguage,
                        data: translation
                    });

                    var updates = {
                        metadata: {
                            language: language
                        },
                        translations: translations
                    };
                    song.update(updates, function () {
                        console.log('saved translation in \'' + language + '\'');
                    });
                });
            });
        });
    }).fail(function (err) {
        console.log(err);
        res.json(500, {
            err: err
        });
    });
});

app.put('/rdio/:rdioKey/:language', function (req, res) {

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