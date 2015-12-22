define [
  'vocabulary.slider.view',
  'vocabulary.list.view',
  'backbone',
  'handlebars',
  'templates'
], (VocabularySliderView, VocabularyListView, Backbone, Handlebars) ->
  VocabularyView = Backbone.View.extend(

    initialize: () ->
      this.vocabularySliderView = new VocabularySliderView(
        model: this.model.vocabularySliderModel
      )

      this.unknownVocabularyListModel = new Backbone.Model(
        words: this.model.get('unknown')
        title: 'Words to Study'
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

    render: () ->
      this.$el.html(Handlebars.templates['vocabulary'](this.model.toJSON()))
      
      subView = this.model.get('subView')
      if 'known' is subView
        this.$('.vocabularyContentContainer').html(this.knownVocabularyListView.render().el)
      else if 'unknown' is subView
        this.$('.vocabularyContentContainer').html(this.unknownVocabularyListView.render().el)
      else
        this.$('.vocabularyContentContainer').html(this.vocabularySliderView.render().el)

      this.$('.unknown').on('click', (event) =>
        this.model.set(
          subView: 'unknown'
        )
        event.preventDefault()
      )
      this.$('.known').on('click', (event) =>
        this.model.set(
          subView: 'known'
        )
        event.preventDefault()
      )

      return this
  )

  return VocabularyView