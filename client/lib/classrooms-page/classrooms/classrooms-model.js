(function() {
  define(['backbone'], function(Backbone) {
    var ClassroomsModel;
    ClassroomsModel = Backbone.Model.extend({
      defaults: {
        currentPage: 0,
        pageSize: 12
      },
      initialize: function() {
        this.paginationModel = new Backbone.Model({
          currentPage: this.get('currentPage'),
          count: 0,
          pageSize: this.get('pageSize')
        });
        return this.getClassrooms(this.get('currentPage'));
      },
      getClassrooms: function(pageToGet) {
        var url,
          _this = this;
        url = '/api/classrooms/page/' + this.get('settings').get('fromLanguage').language;
        url += '?pageSize=' + this.get('pageSize');
        url += '&pageStart=' + (pageToGet * this.get('pageSize'));
        return $.ajax({
          type: 'GET',
          url: url,
          dataType: 'json',
          success: function(res) {
            _this.set({
              data: res.page
            });
            return _this.paginationModel.set({
              count: res.count,
              currentPage: pageToGet
            });
          },
          error: function(err) {
            return console.log('Error: ' + err);
          }
        });
      }
    });
    return ClassroomsModel;
  });

}).call(this);

/*
//@ sourceMappingURL=classrooms-model.js.map
*/