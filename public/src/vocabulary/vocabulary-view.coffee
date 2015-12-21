define [
  'vocabulary.slider.view'
  'backbone',
  'handlebars',
  'templates'
], (VocabularySliderView, Backbone, Handlebars) ->
  VocabularyView = Backbone.View.extend(

    initialize: () ->
      this.vocabularySliderView = new VocabularySliderView(
        model: this.model.vocabularySliderModel
      )

      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['vocabulary'](this.model.toJSON()))
      this.$('.vocabularySliderContainer').html(this.vocabularySliderView.render().el)

      return this
  )

  return VocabularyView