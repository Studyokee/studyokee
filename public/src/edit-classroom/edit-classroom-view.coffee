define [
  'media.item.list.view',
  'backbone',
  'handlebars',
  'templates'
], (MediaItemList, Backbone, Handlebars) ->
  EditClassroomView = Backbone.View.extend(
    className: "edit-classroom"
    
    initialize: () ->
      this.songListView = new MediaItemList(
        model: this.model.songListModel
      )
      this.songSearchListView = new MediaItemList(
        model: this.model.songSearchListModel
      )

      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['edit-classroom'](this.model.toJSON()))

      this.$('.songListContainer').html(this.songListView.render().el)
      this.$('.songSearchListContainer').html(this.songSearchListView.render().el)

      classroom = this.model.get('data')
      if classroom?
        language = ''
        switch classroom.language
          when 'es' then language = 'Spanish'
          when 'fr' then language = 'French'
          when 'de' then language = 'German'
        this.$('#language').val(language)

      this.$('#searchSongs').keyup((event) =>
        query = this.$('#searchSongs').val()

        success = () =>
          if this.$('.songSearchListContainer li').length is 0
            this.$('.songSearchListContainer').hide()
          else
            this.$('.songSearchListContainer').show()
        this.model.searchSongs(query, success)

      )

      this.songSearchListView.on('select', (item) =>
        this.model.addSong(item.song._id)
      )

      this.songListView.on('select', (item) =>
        document.location = '/songs/' + item.song._id + '/edit'
      )

      this.songListView.on('remove', (item) =>
        this.model.removeSong(item.song._id)
      )

      return this

  )

  return EditClassroomView