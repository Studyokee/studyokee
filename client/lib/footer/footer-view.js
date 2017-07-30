(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var FooterView;
    FooterView = Backbone.View.extend({
      tagName: 'footer',
      className: 'container',
      initialize: function() {},
      render: function() {
        this.$el.html(Handlebars.templates['footer'](this.model.toJSON()));
        return this;
      }
    });
    return FooterView;
  });

}).call(this);

/*
//@ sourceMappingURL=footer-view.js.map
*/