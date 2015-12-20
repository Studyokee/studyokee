'use strict';
/*jshint sub:true*/

//  Dependencies
var request = require('request'),
    xml     = require('xml2js');
  
//  Dictionary constructor
var Dictionary = function (config) {
    this.key = config.key;
    this.url = config.url;
};

//  Dictionary functions
Dictionary.prototype = {

    //returns a word's definition
    define: function(word, callback){
        var depth = 0;
        var that = this;
        var rawCallback = function(error, result){
            if (error === null) {
                if (result['entry_list'].entry !== undefined) {
                    var entries = result['entry_list'].entry;
                    if (entries.length > 0) {
                        var filteredEntries = [];
                        for (var i = 0; i < entries.length; i++) {
                            console.log('found word: ' + JSON.stringify(entries[i].hw));
                            //console.log('found word: ' + word.toLowerCase());
                            //if (entries[i].hw && entries[i].hw.length > 0 && (entries[i].hw[0]['_'] === word.toLowerCase() || entries[i].hw[0] === word.toLowerCase())) {
                                
                            console.log('for word: ' + word.toLowerCase());
                            console.log('with result: ' + JSON.stringify(entries[i], null, 4));

                            // if conjugated verb form, return the result for the first cross reference verb
                            if (entries.length === 1 && entries[i].xr && entries[i].xr.length > 0 && entries[i].xr[0].x && entries[i].xr[0].x.length > 0) {
                                return that.raw(entries[i].xr[0].x[0], rawCallback);
                            }

                            filteredEntries.push(entries[i]);
                            //}
                        }
                        callback(null, filteredEntries);
                    }
                } else if (result['entry_list'].suggestion !== undefined && result['entry_list'].suggestion.length > 0) {
                    if (depth === 0) {
                        depth++;
                        return that.raw(result['entry_list'].suggestion[0], rawCallback);
                    }
                }
            } else {
                callback(error);
            }
            callback();
        };
        this.raw(word, rawCallback);
    },

    //return a javascript object equivalent to the XML response from M-W
    raw: function(word, callback){
        request(this.getSearchUrl(word), function (error, response, body) {
            if (!error && response.statusCode === 200) {
                xml.parseString(body, function(error, result){
                    if (error === null) {
                        callback(null, result);
                    } else if (response.statusCode !== 200) {
                        console.log(response.statusCode);
                    } else {
                        console.log(error);
                        callback('XML Parsing error.');
                    }
                });
            } else {
                callback('API connection error.');
            }
        });
    },

    //constructs the search url
    getSearchUrl: function(word){
        return this.url+word+'?key='+this.key;
    }
};

module.exports = Dictionary;