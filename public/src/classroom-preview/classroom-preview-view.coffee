define [
  'backbone',
  'media.item.list.view',
  'handlebars',
  'templates'
], (Backbone, MediaItemList, Handlebars) ->
  ClassroomPreviewView = Backbone.View.extend(
    className: 'classroom-preview'
    tagName: 'li'
    
    initialize: () ->
      this.listenTo(this.model.songListModel, 'change', () =>
        this.render()
      )
      this.songListView = new MediaItemList(
        model: this.model.songListModel
        readonly: true
      )

    render: () ->
      model = this.model.toJSON()
      switch model.classroom.language
        when 'es'
          model.language = 'Spanish'
        when 'fr'
          model.language = 'French'
        when 'de'
          model.language = 'German'

      this.$el.html(Handlebars.templates['classroom-preview'](model))

      this.$('.songListContainer').html(this.songListView.render().el)

      this.$('.classroomLink').on('click', (event) =>
        Backbone.history.navigate('classrooms/' + model.classroom.classroomId, {trigger: true})
        event.preventDefault()
      )

      return this

  )

  return ClassroomPreviewView