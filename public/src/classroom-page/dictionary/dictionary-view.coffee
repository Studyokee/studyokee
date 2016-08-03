define [
  'backbone',
  'handlebars'
], (Backbone, Handlebars) ->

  DictionaryView = Backbone.View.extend(
    className: "dictionary"

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['dictionary'](this.model.toJSON()))

      dictionaryResult = this.model.get('dictionaryResult')
      isLoading = this.model.get('isLoading')

      if isLoading
        # Waiting for response from server
        this.$('.lookup').html(this.getLoadingMessage())
      else if dictionaryResult is null
        # Initial state
        this.$('.lookup').html(this.getInitialMessage())
      else if dictionaryResult is {}
        # Response came back empty
        this.$('.lookup').html(this.getNoResultMessage())

      return this

    getLoadingMessage: () ->
      return '<span class="glyphicon glyphicon-refresh glyphicon-spin"></span>'

    getNoResultMessage: () ->
      return '<span class="text-muted">No result</span>'

    getInitialMessage: () ->
      return '<span class="text-muted">Click on a word to lookup its definition</span>'
                
  )

  return DictionaryView