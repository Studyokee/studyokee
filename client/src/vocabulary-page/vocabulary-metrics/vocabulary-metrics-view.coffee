define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  VocabularyMetricsView = Backbone.View.extend(
    tagName:  'div'
    className: 'vocabulary-metrics'

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      levels = [{label:'Novice',count:0},
        {label:'Beginner',count:250},
        {label:'Intermediate',count:750},
        {label:'Expert',count:2500},
        {label:'Native',count:5000}]

      currentCount = this.model.get('known').length

      nextLevel = levels[1]
      currentLevel = levels[0]

      for i in [1..levels.length-1]
        nextLevel = levels[i]
        currentLevel = levels[i-1]
        if nextLevel.count > currentCount
          break

      renderModel = this.model.toJSON()
      renderModel.currentLevel = currentLevel
      renderModel.nextLevel = nextLevel

      this.$el.html(Handlebars.templates['vocabulary-metrics'](renderModel))

      if nextLevel.count < currentCount
        # native!
        this.$('.progressSection').hide()
      else
        this.$('.levelLabel').html(nextLevel.label)
        percentDone = currentCount*100/nextLevel.count
        withUnknown = this.model.get('unknown').length*100/nextLevel.count
        if (percentDone + withUnknown) > 100
          withUnknown = 100 - percentDone
        this.$('.progress-bar.knownProgress').css('width', percentDone + '%')
        this.$('.progress-bar.unknownProgress').css('width', withUnknown + '%')

        this.$('.progress').attr('title', currentCount + '/' + nextLevel.count + ' words')

      return this
  )

  return VocabularyMetricsView