(function() {
  define(['vocabulary.slider.view', 'vocabulary.list.view', 'vocabulary.metrics.view', 'backbone', 'handlebars', 'purl', 'templates'], function(VocabularySliderView, VocabularyListView, VocabularyMetricsView, Backbone, Handlebars, Purl) {
    var VocabularyView;
    VocabularyView = Backbone.View.extend({
      initialize: function() {
        var _this = this;
        this.vocabularySliderView = new VocabularySliderView({
          model: this.model.vocabularySliderModel
        });
        this.vocabularySliderViewKnown = new VocabularySliderView({
          model: this.model.vocabularySliderModelKnown
        });
        this.vocabularyMetricsView = new VocabularyMetricsView({
          model: this.model
        });
        this.unknownVocabularyListModel = new Backbone.Model({
          words: this.model.get('unknown'),
          title: 'Words to Study',
          link: 'study-unknown'
        });
        this.unknownVocabularyListView = new VocabularyListView({
          model: this.unknownVocabularyListModel
        });
        this.model.on('change:unknown', function() {
          return _this.unknownVocabularyListModel.set({
            words: _this.model.get('unknown')
          });
        });
        this.knownVocabularyListModel = new Backbone.Model({
          words: this.model.get('known'),
          title: 'Words Learned',
          link: 'study-known'
        });
        this.knownVocabularyListView = new VocabularyListView({
          model: this.knownVocabularyListModel
        });
        this.model.on('change:known', function() {
          return _this.knownVocabularyListModel.set({
            words: _this.model.get('known')
          });
        });
        this.listenTo(this.model, 'change', function() {
          return _this.render();
        });
        return $(window).on('hashchange', function() {
          return _this.render();
        });
      },
      render: function() {
        var subView,
          _this = this;
        this.$el.html(Handlebars.templates['vocabulary'](this.model.toJSON()));
        this.$('.vocabularyMetricsContainer').html(this.vocabularyMetricsView.render().el);
        subView = $.url(document.location).attr('fragment');
        if ('known' === subView) {
          this.$('.vocabularyContentContainer').html(this.knownVocabularyListView.render().el);
        } else if ('unknown' === subView) {
          this.$('.vocabularyContentContainer').html(this.unknownVocabularyListView.render().el);
        } else if ('study-known' === subView) {
          this.$('.vocabularyContentContainer').html(this.vocabularySliderViewKnown.render().el);
        } else {
          this.$('.vocabularyContentContainer').html(this.vocabularySliderView.render().el);
        }
        this.$('.saveCard').click(function() {
          var def, word;
          word = _this.$('#makeCardModal .cardWord').val();
          def = _this.$('#makeCardModal .cardDef').val();
          if (word && def) {
            $('#makeCardModal').modal('hide');
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();
            _this.model.addToVocabulary(word, def);
            _this.$('#makeCardModal .cardWord').val('');
            return _this.$('#makeCardModal .cardDef').val('');
          }
        });
        return this;
      }
    });
    return VocabularyView;
  });

}).call(this);

/*
//@ sourceMappingURL=vocabulary-view.js.map
*/