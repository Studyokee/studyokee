define [
  'vocabulary.slider.view',
  'vocabulary.list.view',
  'vocabulary.metrics.view',
  'backbone',
  'handlebars',
  'purl',
  'templates'
], (VocabularySliderView, VocabularyListView, VocabularyMetricsView, Backbone, Handlebars, Purl) ->
  VocabularyView = Backbone.View.extend(

    initialize: () ->
      this.vocabularySliderView = new VocabularySliderView(
        model: this.model.vocabularySliderModel
      )

      this.vocabularySliderViewKnown = new VocabularySliderView(
        model: this.model.vocabularySliderModelKnown
      )

      this.vocabularyMetricsView = new VocabularyMetricsView(
        model: this.model
      )

      this.unknownVocabularyListModel = new Backbone.Model(
        words: this.model.get('unknown')
        title: 'Words to Study'
        link: 'study-unknown'
      )
      this.unknownVocabularyListView = new VocabularyListView(
        model: this.unknownVocabularyListModel
      )
      this.model.on('change:unknown', () =>
        this.unknownVocabularyListModel.set(
          words: this.model.get('unknown')
        )
      )

      this.knownVocabularyListModel = new Backbone.Model(
        words: this.model.get('known')
        title: 'Words Learned'
        link: 'study-known'
      )
      this.knownVocabularyListView = new VocabularyListView(
        model: this.knownVocabularyListModel
      )
      this.model.on('change:known', () =>
        this.knownVocabularyListModel.set(
          words: this.model.get('known')
        )
      )

      this.listenTo(this.model, 'change', () =>
        this.render()
      )
      $(window).on('hashchange', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['vocabulary'](this.model.toJSON()))
      this.$('.vocabularyMetricsContainer').html(this.vocabularyMetricsView.render().el)
      
      subView = $.url(document.location).attr('fragment')
      
      if 'known' is subView
        this.$('.vocabularyContentContainer').html(this.knownVocabularyListView.render().el)
      else if 'unknown' is subView
        this.$('.vocabularyContentContainer').html(this.unknownVocabularyListView.render().el)
      else if 'study-known' is subView
        this.$('.vocabularyContentContainer').html(this.vocabularySliderViewKnown.render().el)
      else
        this.$('.vocabularyContentContainer').html(this.vocabularySliderView.render().el)
      
      return this


  )

  return VocabularyView