define [
  'media.item.list.view',
  'backbone',
  'handlebars',
  'templates'
], (MediaItemList, Backbone, Handlebars) ->
  EditClassroomView = Backbone.View.extend(
    className: "edit-classroom"
    
    initialize: () ->
      this.videoItemListView = new MediaItemList(
        model: this.model.videoItemListModel
      )

      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['edit-classroom'](this.model.toJSON()))

      this.$('.songListContainer').html(this.videoItemListView.render().el)

      classroom = this.model.get('data')
      if classroom
        this.$('#language').val(classroom.language)

      this.$('.cancel').on('click', (event) ->
        document.location = '/'
        event.preventDefault()
      )
      this.$('.save').on('click', (event) =>
        name = this.$('#name').val()
        language = this.$('#language').val()
        this.model.saveClassroom(name, language)
        event.preventDefault()
      )
      this.$('.add').on('click', (event) =>
        id = this.$('#songToAdd').val()
        this.model.addSong(id)
        event.preventDefault()
      )

      return this

  )

  return EditClassroomView