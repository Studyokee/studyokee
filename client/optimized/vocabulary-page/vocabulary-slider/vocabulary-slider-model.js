(function() {
  define(['backbone'], function(Backbone) {
    var VocabularySliderModel;
    VocabularySliderModel = Backbone.Model.extend({
      defaults: {
        words: null,
        index: 0,
        showDefinition: false
      },
      initialize: function() {
        var _this = this;
        return this.on('vocabularyUpdate', function(unknown) {
          var words;
          words = _this.get('words');
          if (words === null || words.length < unknown.length) {
            console.log('sort!');
            return _this.set({
              index: 0,
              words: _this.getRandomOrder(unknown)
            });
          }
        });
      },
      remove: function(index) {
        var word, words;
        words = this.get('words');
        if (index < (words != null ? words.length : void 0)) {
          word = words[index];
          words.splice(index, 1);
          this.set({
            words: words,
            showDefinition: false,
            index: index % words.length
          });
          return this.trigger('removeWord', word.word);
        }
      },
      getRandomOrder: function(array) {
        var i, newArray, order, _i, _j, _len, _ref;
        if (!array || array.length === 0) {
          return [];
        }
        order = [];
        for (i = _i = 0, _ref = array.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          order.push(i);
        }
        order.sort(function() {
          return Math.random() - 0.5;
        });
        newArray = [];
        for (_j = 0, _len = order.length; _j < _len; _j++) {
          i = order[_j];
          newArray.push(array[i]);
        }
        return newArray;
      }
    });
    return VocabularySliderModel;
  });

}).call(this);

/*
//@ sourceMappingURL=vocabulary-slider-model.js.map
*/