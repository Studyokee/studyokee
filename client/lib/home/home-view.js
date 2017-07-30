(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var HomeView;
    HomeView = Backbone.View.extend({
      initialize: function() {},
      render: function() {
        var languageObject;
        this.$el.html(Handlebars.templates['home'](this.model.get('settings').toJSON()));
        languageObject = this.model.get('settings').get('fromLanguage');
        $('.selectLanguage .displayLanguage').text(languageObject.display);
        $('.selectLanguage .dropdown-toggle').attr('data-selected', languageObject.language);
        this.$('.selectLanguage .dropdown-menu a').on('click', function(event) {
          var display, language;
          display = $(this).text();
          language = $(this).attr('data-language');
          $('.selectLanguage .displayLanguage').text(display);
          $('.selectLanguage .dropdown-toggle').attr('data-selected', language);
          $('.try').attr('href', '/try_' + language + '?language=' + language);
          return event.preventDefault();
        });
        return this;
      }
    });
    return HomeView;
  });

}).call(this);

/*
//@ sourceMappingURL=home-view.js.map
*/