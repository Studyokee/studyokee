define [
  'backbone'
], (Backbone) ->
  CreateClassroomModel = Backbone.Model.extend(

    saveClassroom: (name, language, success) ->
      classroom =
        name: name
        language: language
      $.ajax(
        type: 'POST'
        url: '/api/classrooms/'
        dataType: 'json'
        data: classroom
        success: (data, result) =>
          if result is 'success'
            console.log('Success!')
            if success?
              success(data[0])
          else
            console.log('Error: ' + result.responseText)
        error: (result) =>
          console.log('Error: ' + result.responseText)
      )

  )

  return CreateClassroomModel