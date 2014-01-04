'use strict';

var RDIO_API_KEY = process.env.RDIO_API_KEY;
var RDIO_API_SHARED = process.env.RDIO_SHARED_SECRET;
var CALLBACK_URL = '/';
var OAuth = require('oauth').OAuth;

var RDIO_OAUTH_REQUEST = 'http://api.rdio.com/oauth/request_token';
var RDIO_OAUTH_ACCESS = 'http://api.rdio.com/oauth/access_token';
var RDIO_API = 'http://api.rdio.com/1/';

//setup oauth
var oa = new OAuth(
    RDIO_OAUTH_REQUEST,
    RDIO_OAUTH_ACCESS,
    RDIO_API_KEY,
    RDIO_API_SHARED,
    '1.0',
    CALLBACK_URL,
    'HMAC-SHA1'
);

module.exports = {
    getRequestToken: function(callback) {
        oa.getOAuthRequestToken(callback);
    },
    getAccessToken: function(authToken, authTokenSecret, oauthVerifier, callback) {
        oa.getOAuthAccessToken(authToken, authTokenSecret, oauthVerifier, callback);
    },
    getPlaybackToken: function(authToken, authTokenSecret, host, callback) {
        this.api(
            authToken,
            authTokenSecret,
            {
                method: 'getPlaybackToken',
                domain: encodeURIComponent(host)
            },
            callback
        );
    },
    
    api: function(authToken, authTokenSecret, data, callback) {
        oa.post(
            RDIO_API,
            authToken,
            authTokenSecret,
            data,
            null,
            callback
        );
    }
};
