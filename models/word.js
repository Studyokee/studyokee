'use strict';

var mongoose = require('mongoose');

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
    
Word = mongoose.model('Word', wordSchema);
module.exports = Word;