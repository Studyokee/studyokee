define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  ImportWordsView = Backbone.View.extend(

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['import-words'](this.model.toJSON()))

      wordsToAdd = this.model.get('wordsToAdd')
      if wordsToAdd?
        words = Object.keys(wordsToAdd)
        if words.length > 0
          word = words[0]
          # show add word modal
          this.$('.addWords').show()
          this.$('.addWords #word').val(word)
          this.$('.addWords #def').val(wordsToAdd[word])

      this.$('.openImportModal').on('click', (event) =>
        this.$('.importModal').show()
        event.preventDefault()
      )

      this.$('.import').on('click', (event) =>
        raw = this.$('.importModal textarea').val()
        lines = raw.split('\n')
        wordAndDefinitions = {}
        for line in lines
          lineParts = line.split('\t')
          wordAndDefinitions[lineParts[0]] = lineParts[1]

        this.model.addWords(wordAndDefinitions)

        this.$('.importModal').hide()
        this.$('.importModal textarea').val('')
        event.preventDefault()
      )

      this.$('.modal .close').on('click', (event) ->
        $(this).closest('.modal').hide()
      )

      this.$('.addNewWord').on('click', (event) =>
        word = {}
        word.rank = 5001
        word.word = this.$('.addWords #word').val().toLowerCase()
        word.part = this.$('.addWords #part').val()
        word.stem = word.word
        endings = ['a','o','as','os','es']
        str = word.word
        if (str.length > 2 and (word.part is 'adj' or word.part is 'nm' or word.part is 'nf'))
          for suffix in endings
            start = str.indexOf(suffix, str.length - suffix.length)
            if start isnt -1
              # has stem ending, strip down to stem and use that
              word.stem = str.substr(0, start)
        
        word.def = this.$('.addWords #def').val()
        word.example = this.$('.addWords #ex').val()
        word.fromLanguage = 'es'
        word.toLanguage = 'en'

        this.model.addWordToDictionary(word)

        delete wordsToAdd[word.word]

        if wordsToAdd?
          words = Object.keys(wordsToAdd)
          if words.length > 0
            word = words[0]
            this.$('.addWords #word').val(word)
            this.$('.addWords #def').val(wordsToAdd[word])
            this.$('.addWords #ex').val('')
            this.$('.addWords #part').val('')
          else
            this.$('.addWords').hide()
        else
          this.$('.addWords').hide()
          this.model.set(
            wordsToAdd: []
          )
        event.preventDefault()
      )

      return this


  )

  return ImportWordsView