define [
  'backbone',
  'handlebars'
], (Backbone, Handlebars) ->

  DictionaryView = Backbone.View.extend(
    className: "dictionary"

    initialize: () ->
      this.listenTo(this.model, 'change:lookup', () =>
        this.render()
      )
      this.listenTo(this.model, 'change:isLoading', () =>
        this.render()
      )
      this.listenTo(this.model, 'update', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['dictionary'](this.model.toJSON()))

      dictionaryResult = this.model.get('dictionaryResult')
      isLoading = this.model.get('isLoading')

      console.log('isLoading: ' + isLoading)
      console.log('dictionaryResult: ' + dictionaryResult)

      if isLoading
        # Waiting for response from server
        this.$('.lookup').html(this.getLoadingMessage())
      else if dictionaryResult is null
        # Initial state
        this.$('.lookup').html(this.getInitialMessage())
      else if dictionaryResult is undefined
        # Response came back empty
        this.$('.lookup').html(this.getNoResultMessage())

      that = this
      this.$('.lookupEmbed').click((event) ->
        that.render()
        event.preventDefault()
      )

      # this.$('iframe').load(() =>
      #   this.model.set(
      #     isLoading: false
      #   )
      # )

      this.$('.saveCard').click(() =>
        word = this.$('.cardWord').val()
        def = this.$('.cardDef').val()
        if word and def
          $('#makeCardModal').modal('hide')
          $('body').removeClass('modal-open')
          $('.modal-backdrop').remove()
          this.model.addToVocabulary(word, def)
          this.$('.cardWord').val('')
          this.$('.cardDef').val('')
      )

      this.$('.makeCard').click(() =>
        if this.model.get('settings').get('fromLanguage').language is 'es'
          defText = this.$('.lookup').text()
          textParts = defText.split('\n')
          def = ''
          for textPart in textParts
            strippedTextPart = textPart.replace(/^\s+|\s+$/g, '')
            if strippedTextPart.length > 0
              def += strippedTextPart + ', '
          this.$('.cardDef').val(def)
        $('#makeCardModal').modal('show')
      )

      return this

    getLoadingMessage: () ->
      return '<span class="glyphicon glyphicon-refresh glyphicon-spin"></span>'

    getNoResultMessage: () ->
      return '<span class="text-muted">No result</span>'

    getInitialMessage: () ->
      return '<span class="text-muted">Click on a word to lookup its definition</span>'
                
  )

  return DictionaryView