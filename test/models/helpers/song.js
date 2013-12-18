'use strict';

var proxyquire = require('proxyquire');
var mockRequest = require('../../utils/mock-request');
var songHelpers = proxyquire('../../../models/helpers/song', {
    'request': mockRequest.request
});
var chai = require('chai');

describe('song model helpers tests', function () {

    it('getTextChunks test', function (done) {
        var subtitles = [
            {
                text: '01',
                ts: 1
            },
            {
                text: '23',
                ts: 1
            },
            {
                text: '',
                ts: 1
            },
            {
                text: '456',
                ts: 1
            }
        ];
        var chunks = songHelpers.getTextChunks(subtitles, 4);
        chai.expect(chunks.length).to.equal(3);
        done();
    });

    it('getTranslationByLanguageFromArray test', function (done) {
        var esTranslation = {
            language: 'es',
            data: ['esta', 'es', 'la', 'letra']
        };
        var translations = [
            {
                language: 'en',
                data: ['these', 'are', 'lyrics']
            }, esTranslation,
            {
                language: 'fr',
                data: ['ces', 'sont', 'lyrics?']
            }
        ];
        var result = songHelpers.getTranslationByLanguageFromArray(translations, esTranslation.language);
        chai.expect(result.data.length).to.equal(esTranslation.data.length);
        chai.expect(result.data[0]).to.equal(esTranslation.data[0]);
        done();
    });

    it('getArrayFromTuneWikiResult test', function (done) {
        var body = '{"1": {"ts": 0,"text": "I run the argument"},"2": {"ts": 26032,"text": "and methodology"},"3": {"ts": 30490,"text": "every time he appears in front"},"4": {"ts": 34004,"text": "my your anatomy"}}';
        var tuneWikiResult = {
            body: body
        };
        var result = songHelpers.getArrayFromTuneWikiResult(tuneWikiResult);
        chai.expect(result.length).to.equal(4);
        chai.expect(result[0].ts).to.equal(0);
        done();
    });

    it('getSubtitles test', function (done) {
        var artist = 'testArtist';
        var trackName = 'test song';
        var url = songHelpers.getSubtitlesUrl(artist, trackName);
        var body = '{"1": {"ts": 0,"text": "I run the argument"},"2": {"ts": 26032,"text": "and methodology"},"3": {"ts": 30490,"text": "every time he appears in front"},"4": {"ts": 34004,"text": "my your anatomy"}}';

        var res = {
            statusCode: 200,
            body: body
        };

        mockRequest.set(url, res);

        songHelpers.getSubtitles(artist, trackName).then(function (res) {
            chai.expect(res.length).to.equal(4);
            chai.expect(res[0].ts).to.equal(0);
            chai.expect(res[3].ts).to.equal(34004);
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });

    it('getLanguageUrl test', function (done) {
        var subtitles = [
            {
                text: 'test lyric',
                ts: 1
            },
            {
                text: 'test lyric2',
                ts: 1
            },
            {
                text: 'test lyric3',
                ts: 1
            }
        ];
        var url = songHelpers.getLanguageUrl(subtitles);
        console.log(url);
        var expectedUrl = 'https://www.googleapis.com/language/translate/v2/detect?key=AIzaSyCv5VlK9snth6LSqKZM1hocuKYgMsQD8lc&q=test%20lyric%0Atest%20lyric2%0Atest%20lyric3%0A';
        chai.expect(url).to.equal(expectedUrl);
        done();
    });

    it('getLanguage test', function (done) {
        var subtitles = [
            {
                text: 'test lyric',
                ts: 1
            },
            {
                text: 'test lyric',
                ts: 1
            },
            {
                text: 'test lyric',
                ts: 1
            }
        ];
        var url = songHelpers.getLanguageUrl(subtitles);

        var expectedLanguage = 'en';
        var body = '{"data": {"detections": [[{"language": "' + expectedLanguage + '","isReliable": false,"confidence": 0.6764706}]]}}';
        var res = {
            statusCode: 200,
            body: body
        };

        mockRequest.set(url, res);

        songHelpers.getLanguage(subtitles).then(function (res) {
            chai.expect(res).to.equal(expectedLanguage);
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });

    it('getDefaultTranslation test', function (done) {
        var subtitles = [
            {
                text: 'Hello world 0',
                ts: 1
            },
            {
                text: 'Hello world 1',
                ts: 1
            },
            {
                text: 'Hello world 2',
                ts: 1
            }
        ];
        var translation = [
            'Bonjour tout le monde 0',
            'Bonjour tout le monde 1',
            'Bonjour tout le monde 2'
        ];
        var fromLanguage = 'en';
        var toLanguage = 'fr';

        var urls = songHelpers.getTranslationUrls(subtitles, fromLanguage, toLanguage);
        var body = '{"data": {"translations": [{"translatedText": "' + translation[0] + '\\n' + translation[1] + '\\n' + translation[2] + '"}]}}';
        
        var res = {
            statusCode: 200,
            body: body
        };
        mockRequest.set(urls[0], res);

        songHelpers.getDefaultTranslation(subtitles, fromLanguage, toLanguage).then(function (res) {
            chai.expect(res.length).to.equal(translation.length);
            chai.expect(res[0]).to.equal(translation[0]);
            chai.expect(res[2]).to.equal(translation[2]);
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });
});