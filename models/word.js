'use strict';

var mongoose = require('mongoose');
var q = require('q');

var Word;

var wordSchema = mongoose.Schema({
    word: {
        type: String,
        required: true,
        unique: true
    },
    stem: {
        type: String,
        required: true
    },
    fromLanguage: {
        type: String,
        required: true
    },
    toLanguage: {
        type: String,
        required: true
    },
    def: String,
    example: String,
    rank: Number,
    part: String
});
    
function findOne (query) {
    var findOneRequest = q.defer();
    Word.findOne(query, findOneRequest.makeNodeResolver());
    return findOneRequest.promise;
}

function save (saveObj) {
    var word = new Word(saveObj);
    var saveRequest = q.defer();
    word.save(saveRequest.makeNodeResolver());
    return saveRequest.promise.spread(function(res) {
        return res;
    });
}

wordSchema.static('findOrCreate', function (fields) {
    if (!fields.word) {
        return q.reject('No word provided');
    }
    if (!fields.stem) {
        return q.reject('No stem provided');
    }
    if (!fields.fromLanguage) {
        return q.reject('No from language provided');
    }
    if (!fields.toLanguage) {
        return q.reject('No to language provided');
    }

    var search = { word: fields.word, fromLanguage: fields.fromLanguage, toLanguage: fields.toLanguage };

    return findOne(search).then(function (result) {
        if (result) {
            return result;
        }
        
        console.log('failed to find word matching criteria, creating new one...');
        return save(fields).fail(function() {
            // Save failed, try to get again in case concurrent request caused failure
            return findOne(search);
        });
    });
});

Word = mongoose.model('Word', wordSchema);
module.exports = Word;