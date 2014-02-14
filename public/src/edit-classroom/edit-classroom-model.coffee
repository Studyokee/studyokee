define [
  'video.item.list.model',
  'backbone'
], (VideoItemListModel, Backbone) ->
  EditClassroomModel = Backbone.Model.extend(

    initialize: () ->
      this.videoItemListModel = new VideoItemListModel()

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
          this.videoItemListModel.set(
            rawData: res.displayInfos
          )
        error: (err) =>
          console.log('Error: ' + err)
      )

    addSong: (id) ->
      if not id? or id.length is 0
        return

      songs = this.videoItemListModel.get('data') || []
      ids = []
      for song in songs
        if not song?.song?._id
          continue
        if song.song._id is id
          return
        ids.push(song.song._id)

      ids.push(id)
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
  )

  return EditClassroomModel