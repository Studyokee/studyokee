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
        this.raw(word, function(error, result){
            if (error === null) {
                if (result['entry_list'].entry !== undefined) {
                    var entries = result['entry_list'].entry;
                    if (entries.length > 0) {
                        var filteredEntries = [];
                        for (var i = 0; i < entries.length; i++) {
                            console.log('found word: ' + JSON.stringify(entries[i].hw));
                            //console.log('found word: ' + word.toLowerCase());
                            //if (entries[i].hw && entries[i].hw.length > 0 && (entries[i].hw[0]['_'] === word.toLowerCase() || entries[i].hw[0] === word.toLowerCase())) {
                                
                            console.log('added word: ' + word.toLowerCase());
                            filteredEntries.push(entries[i]);
                            //}
                        }
                        callback(null, filteredEntries);
                    }
                } else if (result['entry_list'].suggestion !== undefined) {
                    callback('suggestions', result['entry_list'].suggestion);
                }
            } else {
                callback(error);
            }
            callback();
        });
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