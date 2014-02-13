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
        url: '/api/classroom/'
        dataType: 'json'
        data: classroom
        success: (data, result) =>
          if result is 'success'
            console.log('Success!')
            if success?
              success(data[0])
          else
            console.log('Error: ' + err)
        error: (err) =>
          console.log('Error: ' + err)
      )

  )

  return CreateClassroomModel