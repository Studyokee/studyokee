'use strict';

var mongoose = require('mongoose');
var q = require('q');
var songHelpers = require('./helpers/song');

var Song;

var songSchema = mongoose.Schema({
    rdioKey: {
        type: String,
        required: true,
        unique: true
    },
    metadata: {
        language: String
    },
    rdioData: Object,
    subtitles: [{
        text: String,
        ts: Number
    }],
    translations: [{
        language: String,
        data: [String]
    }]
});

function findOne (query) {
    var findOneRequest = q.defer();
    Song.findOne(query, findOneRequest.makeNodeResolver());
    return findOneRequest.promise;
}

function save (saveObj) {
    var song = new Song(saveObj);
    var saveRequest = q.defer();
    song.save(saveRequest.makeNodeResolver());
    return saveRequest.promise.spread(function(res) {
        return q.resolve(res);
    });
}

songSchema.methods.getTranslation = function(language) {
    return songHelpers.getTranslationByLanguageFromArray(this.translations, language);
};

songSchema.static('getDefaultTranslation', function (subtitles, fromLanguage, toLanguage) {
    return songHelpers.getDefaultTranslation(subtitles, fromLanguage, toLanguage);
});

songSchema.static('getLanguage', function (subtitles) {
    return songHelpers.getLanguage(subtitles);
});

songSchema.static('getSubtitles', function (artist, trackName) {
    return songHelpers.getSubtitles(artist, trackName);
});

songSchema.static('getByRdioKey', function (rdioKey) {
    if (!rdioKey) {
        return q.reject('No rdioKey provided');
    }

    return findOne({ rdioKey: rdioKey }).then(function (song) {
        if (song) {
            return song;
        }
        
        console.log('failed to find rdio key, creating new one...');
        return save({ rdioKey: rdioKey }).fail(function() {
            // Save failed, try to get again in case concurrent request caused failure
            return findOne({ rdioKey: rdioKey });
        });
    });
});

Song = mongoose.model('Song', songSchema);
module.exports = Song;