(function() {
  define(['backbone'], function(Backbone) {
    var HeaderModel;
    HeaderModel = Backbone.Model.extend({
      defaults: {
        vocabularyCount: 0,
        classrooms: []
      },
      initialize: function() {
        this.set({
          user: this.get('settings').get('user'),
          fromLanguage: this.get('settings').get('fromLanguage').language,
          toLanguage: this.get('settings').get('toLanguage').language
        });
        this.on('vocabularyUpdate', function(words) {
          return this.set({
            vocabularyCount: this.getUnknownCount(words)
          });
        });
        this.getVocabularyCount();
        return this.getClassrooms();
      },
      getVocabularyCount: function() {
        var fromLanguage, toLanguage, userId,
          _this = this;
        userId = this.get('settings').get('user').id;
        fromLanguage = this.get('settings').get('fromLanguage').language;
        toLanguage = this.get('settings').get('toLanguage').language;
        if (userId) {
          return $.ajax({
            type: 'GET',
            url: '/api/vocabulary/' + fromLanguage + '/' + toLanguage,
            dataType: 'json',
            success: function(res) {
              if ((res != null ? res.words : void 0) != null) {
                return _this.set({
                  vocabularyCount: _this.getUnknownCount(res.words)
                });
              }
            },
            error: function(err) {
              return console.log('Error: ' + err);
            }
          });
        }
      },
      getUnknownCount: function(words) {
        var unknownCount, word, _i, _len;
        unknownCount = 0;
        for (_i = 0, _len = words.length; _i < _len; _i++) {
          word = words[_i];
          if (!word.known) {
            unknownCount++;
          }
        }
        return unknownCount;
      },
      getClassrooms: function() {
        var url,
          _this = this;
        url = '/api/classrooms/page/' + this.get('settings').get('fromLanguage').language;
        return $.ajax({
          type: 'GET',
          url: url,
          dataType: 'json',
          success: function(res) {
            return _this.set({
              classrooms: res.page
            });
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      },
      updateUser: function(updates, callback) {
        var _this = this;
        return $.ajax({
          type: 'PUT',
          url: '/api/user/',
          data: updates,
          success: function(response) {
            var user;
            console.log('success save: ' + JSON.stringify(response));
            user = _this.get('user');
            user.displayName = updates.displayName;
            user.username = updates.username;
            _this.trigger('change:user');
            if ($.isFunction(callback)) {
              return callback();
            }
          },
          error: function(err) {
            return console.log('err:' + err.responseText);
          }
        });
      }
    });
    return HeaderModel;
  });

}).call(this);

/*
//@ sourceMappingURL=header-model.js.map
*/