define [
  'backbone'
], (Backbone) ->
  HomeModel = Backbone.Model.extend(

    initialize: () ->
      this.getClassrooms()

    getClassrooms: () ->
      $.ajax(
        type: 'GET'
        url: '/api/classrooms/'
        dataType: 'json'
        success: (res) =>
          this.set(
            data: res
          )

        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return HomeModel
