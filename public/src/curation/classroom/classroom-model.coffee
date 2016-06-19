define [
  'youtube.main.model',
  'media.item.list.model',
  'backbone'
], (MainModel, MenuModel, Backbone) ->
  ClassroomModel = Backbone.Model.extend(

    initialize: () ->
      this.mainModel = new MainModel(
        settings: this.get('settings')
        language: this.get('settings').get('toLanguage').language
      )

      this.mainModel.on('change:vocabulary', () =>
        this.trigger('vocabularyUpdate', this.mainModel.get('vocabulary'))
      )

      this.menuModel = new MenuModel(
        settings: this.get('settings')
      )

      this.currentSongModel = new Backbone.Model()

      this.getClassroom()

    getClassroom: () ->
      $.ajax(
        type: 'GET'
        url: '/api/classrooms/' + this.get('id')
        dataType: 'json'
        success: (res) =>
          this.set(
            data: res.classroom
          )
          this.menuModel.set(
            rawData: res.displayInfos
          )
          if res.displayInfos?.length > 0
            firstItem = res.displayInfos[0]
            this.mainModel.set(
              currentSong: firstItem.song
            )
            this.set(
              currentSong: firstItem.song
            )
        error: (err) =>
          console.log('Error: ' + err)
      )
  )

  return ClassroomModel