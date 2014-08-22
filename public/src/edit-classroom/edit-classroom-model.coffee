define [
  'media.item.list.model',
  'create.song.model',
  'backbone'
], (MediaItemListModel, CreateSongModel, Backbone) ->
  EditClassroomModel = Backbone.Model.extend(

    initialize: () ->
      this.songListModel = new MediaItemListModel(
        allowRemove: true
      )

      this.createSongModel = new CreateSongModel()

      this.songSearchListModel = new MediaItemListModel()

      this.updateClassroom()

    updateClassroom: () ->
      $.ajax(
        type: 'GET'
        url: '/api/classrooms/' + this.get('id')
        dataType: 'json'
        success: (res) =>
          this.set(
            data: res.classroom
          )
          this.songListModel.set(
            rawData: res.displayInfos
          )
          this.createSongModel.set(
            defaultLanguage: res.classroom.language
          )
      
        error: (err) =>
          console.log('Error: ' + err)
      )

    addSong: (id) ->
      if not id? or id.length is 0
        return

      songs = this.songListModel.get('data') || []
      ids = []
      for song in songs
        if not song?.song?._id
          continue
        if song.song._id is id
          return
        ids.push(song.song._id)

      ids.push(id)
      this.saveSongs(ids)

    removeSong: (id) ->
      if not id? or id.length is 0
        return

      items = this.songListModel.get('data') || []
      ids = []
      for item in items
        console.log('id: ' + id)
        console.log('item?.song?._id: ' + item?.song?._id)
        if item?.song?._id is id
          continue
        ids.push(item.song._id)
      console.log('ids: ' + JSON.stringify(ids))
      this.saveSongs(ids)

    saveSongs: (ids) ->
      updates =
        songs: ids
      $.ajax(
        type: 'PUT'
        url: '/api/classrooms/' + this.get('id')
        data: updates
        success: () =>
          console.log('success save')
          this.updateClassroom()
        error: (err) =>
          console.log('err:' + err)
      )

    saveClassroom: (name, language) ->
      updates =
        name: name
        language: language
      $.ajax(
        type: 'PUT'
        url: '/api/classrooms/' + this.get('id')
        data: updates
        success: () =>
          console.log('Success!')
          this.updateClassroom()
        error: (err) =>
          console.log('Error: ' + err)
      )

    searchSongs: (query, callback) ->
      if query.trim().length < 1
        this.songSearchListModel.set(
          rawData: []
        )
        callback?()
        return

      data =
        searchQuery: query
      $.ajax(
        type: 'GET'
        url: '/api/songs'
        data: data
        dataType: 'json'
        success: (res) =>
          data = []
          for song in res
            item =
              song: song
            data.push(item)
          this.songSearchListModel.set(
            rawData: data
          )
          callback?()
        error: (err) =>
          console.log('Error: ' + err)
          callback?()
      )
  )

  return EditClassroomModel