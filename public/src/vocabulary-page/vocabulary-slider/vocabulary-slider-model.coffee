define [
  'backbone'
], (Backbone) ->
  VocabularySliderModel = Backbone.Model.extend(
    defaults:
      words: null
      index: 0
      showDefinition: false

    initialize: () ->
      this.on('vocabularyUpdate', (unknown) =>
        # dont update if just less cards, because remove should reorder
        words = this.get('words')
        if words is null or words.length < unknown.length
          console.log('sort!')
          this.set(
            index: 0
            words: this.getRandomOrder(unknown)
          )
      )

    remove: (index) ->
      words = this.get('words')
      if index < words?.length
        word = words[index]
        words.splice(index, 1)
        this.set(
          words: words
          showDefinition: false
          index: index % words.length #if last word is removed
        )
        this.trigger('removeWord', word.word)

    getRandomOrder: (array) ->
      if not array or array.length is 0
        return []

      order = []

      for i in [0..array.length-1]
        order.push(i)

      order.sort(() ->
        return Math.random() - 0.5
      )

      newArray = []
      for i in order
        newArray.push(array[i])

      return newArray

  )

  return VocabularySliderModel