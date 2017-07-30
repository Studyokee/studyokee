(function() {
  define(['backbone'], function(Backbone) {
    var CreateClassroomModel;
    CreateClassroomModel = Backbone.Model.extend({
      saveClassroom: function(name, language, success) {
        var classroom,
          _this = this;
        classroom = {
          name: name,
          language: language
        };
        return $.ajax({
          type: 'POST',
          url: '/api/classrooms/',
          dataType: 'json',
          data: classroom,
          success: function(data, result) {
            if (result === 'success') {
              console.log('Success!');
              if (success != null) {
                return success(data[0]);
              }
            } else {
              return console.log('Error: ' + result.responseText);
            }
          },
          error: function(result) {
            return console.log('Error: ' + result.responseText);
          }
        });
      }
    });
    return CreateClassroomModel;
  });

}).call(this);

/*
//@ sourceMappingURL=create-classroom-model.js.map
*/