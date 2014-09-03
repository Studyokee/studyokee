define [
  'backbone'
], (Backbone) ->
  HomeModel = Backbone.Model.extend(

    initialize: () ->
      this.getClassrooms()

    getClassrooms: () ->
      $.ajax(
        type: 'GET'
        url: '/api/classrooms/page/' + this.get('settings').get('fromLanguage').language
        dataType: 'json'
        success: (res) =>
          this.set(
            data: res.page
          )

        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return HomeModel
