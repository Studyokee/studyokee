'use strict';

// var request = require('supertest');
// var proxyquire = require('proxyquire');
// var q = require('q');

// var express = require('express');
// var app = express();

// app.get('/*', function (req, res, next) {
//     req.rdioData = {
//         artist: 'Test',
//         name: 'test'
//     };
//     req.song = {
//         getTranslation: function () {
//             return [];
//         },
//         update: function () {

//         },
//         metadata: {
//             language: 'en'
//         },
//         translations: []
//     };
//     next();
// });

// var mockSubtitles = proxyquire('../../../../../app/api/songs/translations', {
//     '../../../../models/song': {
//         getSubtitles: function () {
//             return q.resolve().then(function () {
//                 return [];
//             });
//         },
//         getLanguage: function() {
//             return q.resolve().then(function () {
//                 return 'en';
//             });
//         },
//         getDefaultTranslation: function() {
//             return q.resolve().then(function () {
//                 return [];
//             });
//         }
//     }
// });
// app.use(mockSubtitles);

// function url (rdioKey) {
//     return 'api/songs/' + rdioKey + '/translations';
// }

// function getOne (rdioKey, language) {
//     var getRequest = q.defer();
//     request(app)
//         .get(url(rdioKey) + '/' + language)
//         .expect(200)
//         .end(getRequest.makeNodeResolver());
//     return getRequest.promise;
// }

// describe('translations api tests', function () {
//     it('get subtitles returns Song.getSubtitles result', function (done) {
//         var rdioKey = 't3551597';
//         var toLanguage = 'en';

//         getOne(rdioKey, toLanguage).then(function () {
//             done();
//         }).fail(function (err) {
//             if (err) { return done(new Error(err)); }
//         });
//     });

//     it('get translation, already has translation', function (done) {
//         done();
//     });
//     it('get translation, no translation, subtitles error', function (done) {
//         done();
//     });
//     it('get translation, no translation, no subtitles', function (done) {
//         done();
//     });
//     it('get translation, no translation, has language', function (done) {
//         done();
//     });
//     it('get translation, no translation, no language', function (done) {
//         done();
//     });
//     it('get translation, no translation, no language', function (done) {
//         done();
//     });
// });
