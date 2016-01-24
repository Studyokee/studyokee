define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  VocabularyMapView = Backbone.View.extend(
    tagName:  'div'
    className: 'vocabulary-map'

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['vocabulary-map']())

      knownMap = this.model.get('knownMap')
      unknownMap = this.model.get('unknownMap')
      orderedDictionary = this.model.get('orderedDictionary')

      if knownMap? and unknownMap? and orderedDictionary?
        console.log('dictionary length: ' + orderedDictionary.length)
        console.log('known length: ' + Object.keys(knownMap).length)
        console.log('unknown length: ' + Object.keys(unknownMap).length)

        html = ''
        for item in orderedDictionary
          if knownMap[item.word + '&' + item.part]
            html += '<span class="known" data-word="' + item.word + '"></span>'
          else if unknownMap[item.word + '&' + item.part]
            html += '<span class="unknown" data-word="' + item.word + '"></span>'
          else
            html += '<span data-word="' + item.word + '"></span>'

        this.$('.mapChart').html(html)

      return this
  )

  return VocabularyMapView