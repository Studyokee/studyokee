define [
  'backbone'
], (Backbone) ->
  ClassroomsModel = Backbone.Model.extend(
    defaults:
      currentPage: 0
      pageSize: 12

    initialize: () ->
      this.paginationModel = new Backbone.Model(
        currentPage: this.get('currentPage')
        count: 0
        pageSize: this.get('pageSize')
      )
      this.getClassrooms(this.get('currentPage'))

    getClassrooms: (pageToGet) ->
      url = '/api/classrooms/page/' + this.get('settings').get('fromLanguage').language
      url += '?pageSize=' + this.get('pageSize')
      url += '&pageStart=' + (pageToGet * this.get('pageSize'))
      $.ajax(
        type: 'GET'
        url: url
        dataType: 'json'
        success: (res) =>
          this.set(
            data: res.page
          )
          this.paginationModel.set(
            count: res.count
            currentPage: pageToGet
          )


        error: (err) =>
          console.log('Error: ' + err)
      )
  )

  return ClassroomsModel