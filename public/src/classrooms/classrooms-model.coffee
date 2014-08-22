define [
  'backbone'
], (Backbone) ->
  ClassroomsModel = Backbone.Model.extend(

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

    deleteClassroom: (classroom) ->
      $.ajax(
        type: 'DELETE'
        url: '/api/classrooms/' + classroom._id
        success: (res) =>
          this.getClassrooms()
        error: (err) =>
          console.log('Error: ' + err)
      )
  )

  return ClassroomsModel