'use strict';

var request = require('supertest');
var proxyquire = require('proxyquire');
var q = require('q');

var express = require('express');
var app = express();

app.get('/*', function (req, res, next) {
    req.rdioData = {
        artist: 'Test',
        name: 'test'
    };
    next();
});

var mockSubtitles = proxyquire('../../../../../app/api/songs/subtitles', {
    '../../../../models/song': {
        getSubtitles: function () {
            return q.resolve().then(function () {
                return [];
            });
        }
    }
});
app.use(mockSubtitles);

function url (rdioKey) {
    return '/' + rdioKey + '/subtitles';
}

function get (rdioKey) {
    var getRequest = q.defer();
    request(app)
        .get(url(rdioKey))
        .expect(200)
        .end(getRequest.makeNodeResolver());
    return getRequest.promise;
}

describe('subtitles api tests', function () {
    it('get subtitles returns Song.getSubtitles result', function (done) {
        var rdioKey = 't3551597';

        get(rdioKey).then(function () {
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });
});
