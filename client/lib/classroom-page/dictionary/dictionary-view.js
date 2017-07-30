(function() {
  define(['backbone', 'handlebars'], function(Backbone, Handlebars) {
    var DictionaryView;
    DictionaryView = Backbone.View.extend({
      className: "dictionary",
      initialize: function() {
        var _this = this;
        this.listenTo(this.model, 'change:lookup', function() {
          return _this.render();
        });
        this.listenTo(this.model, 'change:isLoading', function() {
          return _this.render();
        });
        return this.listenTo(this.model, 'update', function() {
          return _this.render();
        });
      },
      render: function() {
        var dictionaryResult, isLoading, that,
          _this = this;
        this.$el.html(Handlebars.templates['dictionary'](this.model.toJSON()));
        dictionaryResult = this.model.get('dictionaryResult');
        isLoading = this.model.get('isLoading');
        console.log('isLoading: ' + isLoading);
        console.log('dictionaryResult: ' + dictionaryResult);
        if (isLoading) {
          this.$('.lookup').html(this.getLoadingMessage());
        } else if (dictionaryResult === null) {
          this.$('.lookup').html(this.getInitialMessage());
        } else if (dictionaryResult === void 0) {
          this.$('.lookup').html(this.getNoResultMessage());
        }
        that = this;
        this.$('.lookupEmbed').click(function(event) {
          that.render();
          return event.preventDefault();
        });
        this.$('.saveCard').click(function() {
          var def, word;
          word = _this.$('.cardWord').val();
          def = _this.$('.cardDef').val();
          if (word && def) {
            $('#makeCardModal').modal('hide');
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();
            _this.model.addToVocabulary(word, def);
            _this.$('.cardWord').val('');
            return _this.$('.cardDef').val('');
          }
        });
        this.$('.makeCard').click(function() {
          var def, defText, strippedTextPart, textPart, textParts, _i, _len;
          if (_this.model.get('settings').get('fromLanguage').language === 'es') {
            defText = _this.$('.lookup').text();
            textParts = defText.split('\n');
            def = '';
            for (_i = 0, _len = textParts.length; _i < _len; _i++) {
              textPart = textParts[_i];
              strippedTextPart = textPart.replace(/^\s+|\s+$/g, '');
              if (strippedTextPart.length > 0) {
                def += strippedTextPart + ', ';
              }
            }
            _this.$('.cardDef').val(def);
          }
          return $('#makeCardModal').modal('show');
        });
        return this;
      },
      getLoadingMessage: function() {
        return '<span class="glyphicon glyphicon-refresh glyphicon-spin"></span>';
      },
      getNoResultMessage: function() {
        return '<span class="text-muted">No result</span>';
      },
      getInitialMessage: function() {
        return '<span class="text-muted">Click on a word to lookup its definition</span>';
      }
    });
    return DictionaryView;
  });

}).call(this);

/*
//@ sourceMappingURL=dictionary-view.js.map
*/