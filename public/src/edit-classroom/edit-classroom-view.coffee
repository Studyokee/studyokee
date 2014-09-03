define [
  'media.item.list.view',
  'create.song.view',
  'backbone',
  'handlebars',
  'templates'
], (MediaItemList, CreateSongView, Backbone, Handlebars) ->
  EditClassroomView = Backbone.View.extend(
    className: "edit-classroom"
    
    initialize: () ->
      this.songListView = new MediaItemList(
        model: this.model.songListModel
        allowReorder: true
        allowActions: true
      )

      this.createSongView = new CreateSongView(
        model: this.model.createSongModel
      )

      this.songSearchListView = new MediaItemList(
        model: this.model.songSearchListModel
      )

      this.listenTo(this.model, 'change', () =>
        this.render()
      )

      this.songSearchListView.on('select', (item) =>
        this.model.addSong(item.song._id)
        this.model.songSearchListModel.set(
          rawData: []
        )
        this.$('#searchSongs').val('')
        this.$('.songSearchListContainer').hide()
      )

      this.songListView.on('remove', (item) =>
        if confirm('Remove song from classroom?')
          this.model.removeSong(item.song._id)
      )

      this.songListView.on('view', (item) =>
        Backbone.history.navigate('songs/' + item.song._id + '/edit', {trigger: true})
      )

      this.songListView.on('reorder', (ids) =>
        this.model.saveSongs(ids)
      )

      this.createSongView.on('saveSuccess', (song) =>
        this.$('.addNewSongModal').hide()
        this.model.addSong(song._id)
      )
      this.createSongView.on('cancel', (song) =>
        this.$('.addNewSongModal').hide()
      )

    render: () ->
      this.$el.html(Handlebars.templates['edit-classroom'](this.model.toJSON()))

      this.$('.songListContainer').html(this.songListView.render().el)
      this.$('.songSearchListContainer').html(this.songSearchListView.render().el)
      this.$('.addNewSongContainer').html(this.createSongView.render().el)
      if this.model.get('data')?.songs?.length
        this.$('.songCount').html('(' + this.model.get('data').songs.length + ')')

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
        this.model.searchSongs(query)

      )
      this.$('#searchSongs').focus((event) =>
        this.$('.songSearchListContainer').show()
      )
      this.$('#searchSongs').blur((event) =>
        if not this.$('#searchSongs').val()
          this.$('.songSearchListContainer').hide()
      )

      this.$('.addNewSong').on('click', () =>
        this.$('.addNewSongModal').show()
        this.$('.addNewSongModal .modal').show()
      )

      this.$('.closeAddSongModal').on('click', () =>
        this.$('.addNewSongModal').hide()
      )

      this.$('.viewClassroom').on('click', (e) =>
        Backbone.history.navigate('classrooms/' + this.model.get('data')?.classroomId, {trigger: true})
        e.preventDefault()
      )

      this.$('.deleteClassroom').on('click', (event) =>
        if confirm('Are you sure you want to delete this classroom?')
          this.model.deleteClassroom(this.model.get('data'))
          Backbone.history.navigate('/', {trigger: true})
      )

      return this

  )

  return EditClassroomView