'use strict';

var mockRequest = {
    urlMocks: [],
    set: function(url, res) {
        var mock = {
            url: url,
            res: res
        };
        mockRequest.urlMocks.push(mock);
    },
    request: function(url, callback) {
        for (var i = 0; i < mockRequest.urlMocks.length; i++) {
            var mock = mockRequest.urlMocks[i];
            if (url === mock.url) {
                return callback(null, mock.res, mock.res.body);
            }
        }
        console.log('mock-request: ' + url);
        callback(null);
    }
};

module.exports = mockRequest;