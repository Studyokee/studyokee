(function() {
  define(['vocabulary.slider.model', 'backbone'], function(VocabularySliderModel, Backbone) {
    var VocabularyModel;
    VocabularyModel = Backbone.Model.extend({
      defaults: {
        known: [],
        unknown: []
      },
      initialize: function() {
        var _this = this;
        this.vocabularySliderModel = new VocabularySliderModel();
        this.vocabularySliderModelKnown = new VocabularySliderModel();
        this.vocabularySliderModel.on('removeWord', function(word) {
          return _this.remove(word);
        });
        this.vocabularySliderModel.on('updateWord', function(word) {
          return _this.updateWord(word);
        });
        this.on('vocabularyUpdate', function() {
          _this.vocabularySliderModel.trigger('vocabularyUpdate', _this.get('unknown'));
          return _this.vocabularySliderModelKnown.trigger('vocabularyUpdate', _this.get('known'));
        });
        return this.getVocabulary();
      },
      getVocabulary: function() {
        var fromLanguage, toLanguage, userId,
          _this = this;
        userId = this.get('settings').get('user').id;
        fromLanguage = this.get('settings').get('fromLanguage').language;
        toLanguage = this.get('settings').get('toLanguage').language;
        return $.ajax({
          type: 'GET',
          url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage,
          dataType: 'json',
          success: function(res) {
            return _this.updateVocabulary(res);
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      },
      remove: function(word) {
        var fromLanguage, toLanguage, userId,
          _this = this;
        userId = this.get('settings').get('user').id;
        fromLanguage = this.get('settings').get('fromLanguage').language;
        toLanguage = this.get('settings').get('toLanguage').language;
        return $.ajax({
          type: 'PUT',
          url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage + '/remove',
          data: {
            word: word
          },
          success: function(res) {
            return _this.updateVocabulary(res);
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      },
      updateWord: function(word, def) {
        var fromLanguage, toLanguage,
          _this = this;
        if (word == null) {
          return;
        }
        fromLanguage = this.get('settings').get('fromLanguage').language;
        toLanguage = this.get('settings').get('toLanguage').language;
        return $.ajax({
          type: 'PUT',
          url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage + '/update',
          data: {
            word: word
          },
          success: function(res) {},
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      },
      updateVocabulary: function(vocabulary) {
        var sortedWords;
        if ((vocabulary != null ? vocabulary.words : void 0) != null) {
          sortedWords = this.sortWords(vocabulary.words);
          this.set({
            known: sortedWords.known,
            unknown: sortedWords.unknown
          });
          return this.trigger('vocabularyUpdate', vocabulary.words);
        }
      },
      sortWords: function(words) {
        var known, sortedWords, unknown, word, _i, _len;
        known = [];
        unknown = [];
        for (_i = 0, _len = words.length; _i < _len; _i++) {
          word = words[_i];
          if (word.known) {
            known.push(word);
          } else {
            unknown.push(word);
          }
        }
        sortedWords = {
          known: known,
          unknown: unknown
        };
        return sortedWords;
      },
      addToVocabulary: function(word, def) {
        var fromLanguage, toLanguage,
          _this = this;
        if (word == null) {
          return;
        }
        fromLanguage = this.get('settings').get('fromLanguage').language;
        toLanguage = this.get('settings').get('toLanguage').language;
        return $.ajax({
          type: 'PUT',
          url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage + '/add',
          data: {
            word: word,
            def: def
          },
          success: function(res) {
            return _this.updateVocabulary(res);
          },
          error: function(err) {
            return console.log('Error adding to vocabulary');
          }
        });
      }
    });
    return VocabularyModel;
  });

}).call(this);

/*
//@ sourceMappingURL=vocabulary-model.js.map
*/