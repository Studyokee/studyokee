define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->

  VocabularyView = Backbone.View.extend(

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['vocabulary'](this.model.toJSON()))
      view = this
      this.$('.card').each(() ->
        if view.model.get('index') is parseInt($(this).attr('data-index'))
          $(this).show()
        else
          $(this).hide()
      )

      this.$('.wordOrPhrase').on('click', () ->
        $(this).hide()
        $(this).closest('.card').find('.definition').show()
      )
      this.$('.definition').on('click', () ->
        nextIndex = (view.model.get('index')+1) % view.model.get('words').length
        view.model.set(
          index: nextIndex
        )
      )
      this.$('.remove').on('click', () ->
        index = $(this).closest('.card').attr('data-index')
        view.model.remove(index)
      )

      if this.model.get('words')?.length is 0
        this.$('.vocabulary').html('No words or phrases have been added!')
      
  )

  return VocabularyView