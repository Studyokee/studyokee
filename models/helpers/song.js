'use strict';

var q = require('q');
var request = require('request');

var splitToken = '\n';
var googleURLChunkSize = 500;

function getTextChunks (subtitles, chunkSize) {
    var chunks = [];
    var chunk = '';

    for (var i = 0; i < subtitles.length; i++) {
        var line = subtitles[i].text;
        if (i < subtitles.length) {
            line += splitToken;
        }

        if (line.length > chunkSize) {
            console.log('panic!!!!');
            break;
        }

        if ((chunk.length + line.length) <= chunkSize) {
            chunk += line;
        } else {
            chunks.push(chunk);
            chunk = line;
        }
    }

    if (chunk.length !== 0) {
        chunks.push(chunk);
    }

    return chunks;
}

function getSubtitlesUrl (artist, trackName) {
    var url = 'http://d378swyygivki.cloudfront.net/lyrics?';
    url += 'artist=' + artist;
    url += '&song=' + trackName;
    console.log(url);
    return url;
}

function getLanguageUrl (subtitles) {
    var chunks = getTextChunks(subtitles, googleURLChunkSize);

    var url = 'https://www.googleapis.com/language/translate/v2/detect?';
    url += 'key=' + process.env.GOOGLE_API_KEY;
    url += '&q=' + encodeURI(chunks[0]);
    console.log(url);
    return url;
}

function getTranslationUrls (subtitles, fromLanguage, toLanguage) {
    var chunks = getTextChunks(subtitles, googleURLChunkSize);
    var urls = [];

    for (var i = 0; i < chunks.length; i++) {
        var url = 'https://www.googleapis.com/language/translate/v2?';
        url += 'key=' + process.env.GOOGLE_API_KEY;
        url += '&q=' + encodeURI(chunks[i]);
        url += '&source=' + fromLanguage;
        url += '&target=' + toLanguage;
        url += '&format=text';
        console.log(url);
        urls.push(url);
    }

    return urls;
}

function getArrayFromTuneWikiResult (res) {
    if (res.body) {
        var subtitlesObject = JSON.parse(res.body);
        var subtitlesArray = [];
        var i = 0;
        while (subtitlesObject[i+1]) {
            subtitlesArray.push(subtitlesObject[i+1]);
            i++;
        }
        return subtitlesArray;
    } else {
        return [];
    }
}

function getLanguageFromGoogleResult (res) {
    return JSON.parse(res).data.detections[0][0].language;
}

function getTranslationFromGoogleResult (res) {
    return JSON.parse(res[1]).data.translations[0].translatedText;
}

function getSubtitles (artist, trackName) {
    var getSubtitlesRequest = q.defer();
    var url = getSubtitlesUrl(artist, trackName);
    request(url, getSubtitlesRequest.makeNodeResolver());

    return getSubtitlesRequest.promise.spread(getArrayFromTuneWikiResult);
}

function getLanguage (subtitles) {
    if (!subtitles || subtitles.length === 0) {
        return q.reject('No text provided');
    }

    var detectLanguageRequest = q.defer();
    var url = getLanguageUrl(subtitles);
    request(url, detectLanguageRequest.makeNodeResolver());

    return detectLanguageRequest.promise.spread(function(res, body) {
        return getLanguageFromGoogleResult(body);
    });
}

function getDefaultTranslation (subtitles, fromLanguage, toLanguage) {
    if (!subtitles || subtitles.length === 0 || !fromLanguage || !toLanguage) {
        return q.reject('Proper params not provided');
    }

    var urls = getTranslationUrls(subtitles, fromLanguage, toLanguage);

    var requests = [];
    for (var i = 0; i < urls.length; i++) {
        var getTranslationRequest = q.defer();
        request(urls[i], getTranslationRequest.makeNodeResolver());
        requests.push(getTranslationRequest.promise);
    }

    return q.all(requests).then(function (res) {
        var segments = [];
        for (var j = 0; j < res.length; j++) {
            segments.push(getTranslationFromGoogleResult(res[j]));
        }

        return segments.join('').split(splitToken);
    });
}

function getByLanguageFromArray (arr, language) {
    if (!arr || !language) {
        return q.reject('Proper params not provided');
    }

    for (var i = 0; i < arr.length; i++) {
        if (arr[i].language === language) {
            return arr[i];
        }
    }
}

module.exports = {
    getSubtitlesUrl: getSubtitlesUrl,
    getLanguageUrl: getLanguageUrl,
    getTranslationUrls: getTranslationUrls,
    getArrayFromTuneWikiResult: getArrayFromTuneWikiResult,
    getLanguageFromGoogleResult: getLanguageFromGoogleResult,
    getTranslationFromGoogleResult: getTranslationFromGoogleResult,
    getSubtitles: getSubtitles,
    getLanguage: getLanguage,
    getTextChunks: getTextChunks,
    getDefaultTranslation: getDefaultTranslation,
    getByLanguageFromArray: getByLanguageFromArray
};