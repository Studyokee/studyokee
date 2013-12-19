'use strict';

var mongoose = require('mongoose');
mongoose.connect(process.env.MONGO_URL);

var ViewCounter = require('../../models/viewCounter');
var chai = require('chai');
var q = require('q');

describe('viewCounter model tests', function () {

    it('getViewCounter test with new viewCounter creates new one and returns it', function (done) {
        var fromLanguage = 'es';
        var toLanguage = 'en';
        var rdioKey = new Date().getTime().toString();

        q.resolve().then(function () {
            return ViewCounter.getViewCounter(fromLanguage, toLanguage, rdioKey);
        }).then(function (viewCounter) {
            chai.expect(viewCounter.fromLanguage).to.equal(fromLanguage);
            chai.expect(viewCounter.toLanguage).to.equal(toLanguage);
            chai.expect(viewCounter.rdioKey).to.equal(rdioKey);
            chai.expect(viewCounter.viewCount).to.equal(0);

            // Check one was created in db
            var findRequest = q.defer();
            ViewCounter.find({
                fromLanguage: fromLanguage,
                toLanguage: toLanguage,
                rdioKey: rdioKey
            }, findRequest.makeNodeResolver());
            return findRequest.promise;
        }).then(function (matches) {
            chai.expect(matches.length).to.equal(1);
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });

    it('getViewCounter test when view exists finds it and doesnt create new', function (done) {
        var fromLanguage = 'es';
        var toLanguage = 'en';
        var rdioKey = new Date().getTime().toString();

        q.resolve().then(function () {
            // Do a get to create one
            return ViewCounter.getViewCounter(fromLanguage, toLanguage, rdioKey);
        }).then(function () {
            return ViewCounter.getViewCounter(fromLanguage, toLanguage, rdioKey);
        }).then(function (viewCounter) {
            chai.expect(viewCounter.fromLanguage).to.equal(fromLanguage);
            chai.expect(viewCounter.toLanguage).to.equal(toLanguage);
            chai.expect(viewCounter.rdioKey).to.equal(rdioKey);
            chai.expect(viewCounter.viewCount).to.equal(0);

            // Check only one was created
            var findRequest = q.defer();
            ViewCounter.find({
                fromLanguage: fromLanguage,
                toLanguage: toLanguage,
                rdioKey: rdioKey
            }, findRequest.makeNodeResolver());
            return findRequest.promise;
        }).then(function (matches) {
            chai.expect(matches.length).to.equal(1);
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });

    it('logView test', function (done) {
        var fromLanguage = 'es';
        var toLanguage = 'en';
        var rdioKey = new Date().getTime().toString();

        q.resolve().then(function () {
            // Do a get to create one
            return ViewCounter.logView(fromLanguage, toLanguage, rdioKey);
        }).then(function () {
            // Check only one was created
            var findOneRequest = q.defer();
            ViewCounter.findOne({
                fromLanguage: fromLanguage,
                toLanguage: toLanguage,
                rdioKey: rdioKey
            }, findOneRequest.makeNodeResolver());
            return findOneRequest.promise;
        }).then(function (viewCounter) {
            chai.expect(viewCounter.fromLanguage).to.equal(fromLanguage);
            chai.expect(viewCounter.toLanguage).to.equal(toLanguage);
            chai.expect(viewCounter.rdioKey).to.equal(rdioKey);
            chai.expect(viewCounter.viewCount).to.equal(1);
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });

    it('getTopViewed test', function (done) {
        var unique = new Date().getTime();
        var fromLanguage = 'es' + unique;
        var toLanguage = 'en' + unique;
        var rdioKey0 = unique.toString() + 'a';
        var rdioKey1 = unique.toString() + 'b';
        var rdioKey2 = unique.toString() + 'c';

        // Note: concurrency issues...
        q.resolve().then(function () {
            return q.all([
                ViewCounter.logView(fromLanguage, toLanguage, rdioKey0),
                ViewCounter.logView(fromLanguage, toLanguage, rdioKey1),
                ViewCounter.logView(fromLanguage, toLanguage, rdioKey2)
            ]);
        }).then(function () {
            return q.all([
                ViewCounter.logView(fromLanguage, toLanguage, rdioKey1),
                ViewCounter.logView(fromLanguage, toLanguage, rdioKey2)
            ]);
        }).then(function () {
            return ViewCounter.logView(fromLanguage, toLanguage, rdioKey2);
        }).then(function () {
            return ViewCounter.getTopViewed(fromLanguage, toLanguage);
        }).then(function (viewCounters) {
            chai.expect(viewCounters.length).to.equal(3);
            chai.expect(viewCounters[0].viewCount).to.equal(3);
            chai.expect(viewCounters[1].viewCount).to.equal(2);
            chai.expect(viewCounters[2].viewCount).to.equal(1);
            done();
        }).fail(function (err) {
            if (err) { return done(new Error(err)); }
        });
    });
});