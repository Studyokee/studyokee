define [
  'dictionary.model',
  'youtube.main.model',
  'media.item.list.model',
  'backbone'
], (DictionaryModel, MainModel, MenuModel, Backbone) ->
  ClassroomModel = Backbone.Model.extend(

    initialize: () ->
      this.mainModel = new MainModel(
        settings: this.get('settings')
        language: 'en'
      )

      this.menuModel = new MenuModel(
        settings: this.get('settings')
      )

      this.dictionaryModel = new DictionaryModel(
        fromLanguage: this.get('settings').get('fromLanguage')
        toLanguage: 'en'
        settings: this.get('settings')
      )

      this.getClassroom()

    lookup: (query) ->
      this.dictionaryModel.set(
        query: query
      )

    getClassroom: () ->
      $.ajax(
        type: 'GET'
        url: '/api/classrooms/' + this.get('id')
        dataType: 'json'
        success: (res) =>
          this.set(
            data: res.classroom
          )
          this.dictionaryModel.set(
            fromLanguage: res.classroom.language
          )
          this.menuModel.set(
            rawData: res.displayInfos
          )
          if res.displayInfos?.length > 0
            firstItem = res.displayInfos[0]
            this.mainModel.trigger('changeSong', firstItem.song)
        error: (err) =>
          console.log('Error: ' + err)
      )
  )

  return ClassroomModel