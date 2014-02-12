'use strict';

var mongoose = require('mongoose');
var assert = require('assert');
var q = require('q');

var Counter;

var counterSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true
    },
    count: Number
});

counterSchema.static('getNext', function (name) {
    var count = null;
    return q.resolve().then(function () {
        return Counter.getCounter(name);
    }).then(function (counter) {
        count = counter.count + 1;
        var updates = {
            count: count
        };
        var updateRequest = q.defer();
        counter.update(updates, updateRequest.makeNodeResolver());
        return updateRequest.promise;
    }).then(function () {
        return count;
    });
});

counterSchema.static('getCounter', function (name) {
    assert(name, 'No name provided');

    return q.resolve().then(function () {
        var findRequest = q.defer();
        Counter.findOne({
            name: name
        }, findRequest.makeNodeResolver());

        return findRequest.promise;
    }).then(function (counter) {
        if (counter) {
            return counter;
        }

        console.log('failed to find counter object, creating new one...');
        counter = new Counter({
            name: name,
            count: 0
        });
        var saveRequest = q.defer();
        counter.save(saveRequest.makeNodeResolver());
        return saveRequest.promise.spread(function(res) {
            return q.resolve(res);
        }).fail(function() {
            var findRetryRequest = q.defer();
            Counter.findOne({
                name: name
            }, findRetryRequest.makeNodeResolver());
            return findRetryRequest.promise;
        });
    }).fail(function (err) {
        console.log('err: '+ err);
    });
});

Counter = mongoose.model('Counter', counterSchema);
module.exports = Counter;