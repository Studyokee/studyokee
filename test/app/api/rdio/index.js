'use strict';

var request = require('supertest');
var chai = require('chai');
var q = require('q');

var app = require('../../../../app/api/rdio');

describe('rdio tests', function () {

    it('empty search test', function (done) {
        q.resolve().then(function () {
            var getRequest = q.defer();
            request(app)
                .get('/search/')
                .expect(404)
                .end(getRequest.makeNodeResolver());
            return getRequest.promise;
        }).then(function () {
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });

    it('search test', function (done) {
        var query = 'test';

        q.resolve().then(function () {
            var getRequest = q.defer();
            request(app)
                .get('/search/' + query)
                .expect(200)
                .end(getRequest.makeNodeResolver());
            return getRequest.promise;
        }).then(function (res) {
            chai.expect(res.body.length).to.be.above(0);
            chai.expect(res.body[0].artist).to.be.a('string');
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });
});