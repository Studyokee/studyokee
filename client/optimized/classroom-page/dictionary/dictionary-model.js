(function() {
  define(['backbone'], function(Backbone) {
    var DictionaryModel;
    DictionaryModel = Backbone.Model.extend({
      initialize: function() {
        var _this = this;
        this.set({
          isLoading: false,
          dictionaryResult: null,
          isDE: this.get('settings').get('fromLanguage').language === 'de'
        });
        return this.listenTo(this, 'change:query', function() {
          var query;
          query = _this.get('query');
          _this.set({
            dictionaryResult: null,
            lookup: query
          });
          return _this.lookup(query);
        });
      },
      lookup: function(query) {
        var fromLanguage, toLanguage,
          _this = this;
        fromLanguage = this.get('settings').get('fromLanguage').language;
        this.set({
          isLoading: true
        });
        if (fromLanguage === 'de') {
          return;
        }
        toLanguage = this.get('settings').get('toLanguage').language;
        return $.ajax({
          type: 'GET',
          dataType: 'json',
          url: '/api/dictionary/' + fromLanguage + '/' + toLanguage + '?word=' + query,
          success: function(result) {
            if (result === null) {
              result = void 0;
            }
            _this.set({
              dictionaryResult: result,
              isLoading: false
            });
            return _this.trigger('update');
          },
          error: function(error) {
            _this.set({
              isLoading: false
            });
            return console.log('Error looking up word');
          }
        });
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
            return _this.trigger('wordAdded', res.words);
          },
          error: function(err) {
            return console.log('Error adding to vocabulary');
          }
        });
      }
    });
    return DictionaryModel;
  });

}).call(this);

/*
//@ sourceMappingURL=dictionary-model.js.map
*/