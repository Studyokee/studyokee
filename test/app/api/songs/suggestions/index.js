// 'use strict';

// var request = require('supertest');
// var chai = require('chai');
// var q = require('q');

// var proxyquire = require('proxyquire');
// var viewCounter = {};
// var app = proxyquire('../../../../../app/api/songs/suggestions', {
//     '../../../../models/viewCounter': viewCounter
// });

// describe('suggestions tests', function () {

//     it('suggestions when no view counts exist for lang', function (done) {
//         var unique = new Date().getTime();
//         var fromLanguage = 'fake1' + unique;
//         var toLanguage = 'fake2' + unique;

//         viewCounter.getTopViewed = function () {
//             return [];
//         };

//         q.resolve().then(function () {
//             var getRequest = q.defer();
//             request(app)
//                 .get('/' + toLanguage + '/' + fromLanguage)
//                 .expect(200)
//                 .end(getRequest.makeNodeResolver());
//             return getRequest.promise;
//         }).then(function (res) {
//             chai.expect(res.body.length).to.equal(0);
//             done();
//         }).fail(function (err) {
//             if (err) { return done(new Error(err)); }
//         });
//     });

//     it('suggestions when view counts exist for lang', function (done) {
//         var unique = new Date().getTime();
//         var fromLanguage = 'en' + unique;
//         var toLanguage = 'es' + unique;
//         var rdioKey1 = 't17678678';
//         var rdioKey2 = 't1241123';

//         viewCounter.getTopViewed = function () {
//             return [{
//                 rdioKey: rdioKey1
//             },{
//                 rdioKey: rdioKey2
//             }];
//         };

//         q.resolve().then(function () {
//             var getRequest = q.defer();
//             request(app)
//                 .get('/' + fromLanguage + '/' + toLanguage)
//                 .expect(200)
//                 .end(getRequest.makeNodeResolver());
//             return getRequest.promise;
//         }).then(function (res) {
//             chai.expect(res.body[0].key).to.equal(rdioKey1);
//             chai.expect(res.body[1].key).to.equal(rdioKey2);
//             done();
//         }).fail(function (err) {
//             if (err) { return done(new Error(err)); }
//         });
//     });
// });