define [
  'import.words.view',
  'vocabulary.slider.view',
  'vocabulary.list.view',
  'vocabulary.metrics.view',
  'vocabulary.map.view',
  'backbone',
  'handlebars',
  'purl',
  'templates'
], (ImportWordsView, VocabularySliderView, VocabularyListView, VocabularyMetricsView, VocabularyMapView, Backbone, Handlebars, Purl) ->
  VocabularyView = Backbone.View.extend(

    initialize: () ->
      this.importWordsView = new ImportWordsView(
        model: this.model.importWordsModel
      )

      this.vocabularySliderView = new VocabularySliderView(
        model: this.model.vocabularySliderModel
      )

      this.vocabularyMetricsView = new VocabularyMetricsView(
        model: this.model
      )
      this.vocabularyMapView = new VocabularyMapView(
        model: this.model.vocabularyMapModel
      )

      this.unknownVocabularyListModel = new Backbone.Model(
        words: this.model.get('unknown')
        title: 'Words to Study'
        link: 'study'
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
      this.$('.importWordsContainer').html(this.importWordsView.render().el)
      this.$('.vocabularyMapContainer').html(this.vocabularyMapView.render().el)
      
      subView = $.url(document.location).attr('fragment')
      console.log(subView)
      if 'known' is subView
        this.$('.vocabularyContentContainer').html(this.knownVocabularyListView.render().el)
      else if 'unknown' is subView
        this.$('.vocabularyContentContainer').html(this.unknownVocabularyListView.render().el)
      else
        this.$('.vocabularyContentContainer').html(this.vocabularySliderView.render().el)
      
      this.$('.addNext').on('click', (event) =>
        this.model.addNext()
        event.preventDefault()
      )

      return this


  )

  return VocabularyView