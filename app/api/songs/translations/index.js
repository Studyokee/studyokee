'use strict';

var Song = require('../../../../models/song');
//var ViewCounter = require('../../../../models/viewCounter');

var express = require('express');
var q = require('q');
var app = express();
var assert = require('assert');

app.get('/:rdioKey/translations/:language', function (req, res) {
    assert(req.hasOwnProperty('song'));

    var toLanguage = req.params.language;
    var song = req.song;
    var translation = song.getTranslation(toLanguage);

    if (translation && translation.data) {
        console.log('found existing translation');
        res.json(200, translation.data);
        //ViewCounter.logView(req.song.metadata.language, toLanguage, req.params.rdioKey);
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
                    
                    //ViewCounter.logView(language, toLanguage, req.params.rdioKey);
                });
            });
        });
    }).fail(function (err) {
        console.log('no subtitles2');
        console.log(err);
        res.json(500, {
            err: err
        });
    });

    
});

module.exports = app;