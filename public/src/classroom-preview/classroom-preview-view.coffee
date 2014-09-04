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
        limit: 5
      )

    render: () ->
      model = this.model.toJSON()

      this.$el.html(Handlebars.templates['classroom-preview'](model))

      this.$('.songListContainer').html(this.songListView.render().el)

      this.$('.classroomLink').on('click', (event) =>
        Backbone.history.navigate('classrooms/' + model.classroom.classroomId, {trigger: true})
        event.preventDefault()
      )

      return this

  )

  return ClassroomPreviewView