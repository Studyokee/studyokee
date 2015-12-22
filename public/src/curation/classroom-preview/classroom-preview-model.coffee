define [
  'backbone',
  'media.item.list.model'
], (Backbone, MediaItemListModel) ->
  ClassroomPreviewModel = Backbone.Model.extend(

    initialize: () ->
      this.songListModel = new MediaItemListModel(
        rawData: this.get('songDisplayInfos')
      )
      if this.get('classroom')?.songs?.length > 0
        this.getDisplayInfo(this.get('classroom').songs)
      else
        this.songListModel.trigger('change')


    getDisplayInfo: (ids) ->
      data =
        ids: ids
      $.ajax(
        type: 'GET'
        url: '/api/songs/display'
        data: data
        dataType: 'json'
        success: (res) =>
          this.songListModel.set(
            rawData: res
          )
        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return ClassroomPreviewModel