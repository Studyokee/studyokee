(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var VocabularyListView;
    VocabularyListView = Backbone.View.extend({
      tagName: 'div',
      className: 'vocabulary-list',
      initialize: function() {
        var _this = this;
        return this.listenTo(this.model, 'change', function() {
          return _this.render();
        });
      },
      render: function() {
        this.$el.html(Handlebars.templates['vocabulary-list'](this.model.toJSON()));
        return this;
      }
    });
    return VocabularyListView;
  });

}).call(this);

/*
//@ sourceMappingURL=vocabulary-list-view.js.map
*/