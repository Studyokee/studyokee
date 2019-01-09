(function() {
  define(['backbone'], function(Backbone) {
    var SettingsModel, fromLanguages, toLanguages;
    toLanguages = [
      {
        'language': 'en',
        'display': 'English'
      }
    ];
    fromLanguages = [
      {
        'language': 'es',
        'display': 'Spanish'
      }
    ];
    SettingsModel = Backbone.Model.extend({
      defaults: {
        enableLogging: true,
        defaultToLanguage: toLanguages[0],
        defaultFromLanguage: fromLanguages[0],
        toLanguage: toLanguages[0],
        fromLanguage: fromLanguages[0],
        user: {
          id: '',
          displayName: '',
          username: '',
          admin: false
        },
        supportedLanguages: fromLanguages
      },
      setFromLangauge: function(language) {
        var item, _i, _len;
        for (_i = 0, _len = fromLanguages.length; _i < _len; _i++) {
          item = fromLanguages[_i];
          if (item.language === language) {
            this.set({
              fromLanguage: item
            });
            return;
          }
        }
      }
    });
    return SettingsModel;
  });

}).call(this);

/*
//@ sourceMappingURL=settings.js.map
*/