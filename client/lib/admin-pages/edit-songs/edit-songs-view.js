(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var EditSongsView;
    EditSongsView = Backbone.View.extend({
      className: "editSongs",
      initialize: function() {
        var _this = this;
        return this.listenTo(this.model, 'change', function() {
          return _this.render();
        });
      },
      render: function() {
        var view;
        this.$el.html(Handlebars.templates['edit-songs'](this.model.toJSON()));
        view = this;
        this.$('.remove').on('click', function() {
          var index, songs;
          if (confirm('Delete this song?')) {
            songs = view.model.get('data');
            index = $(this).attr('data-index');
            return view.model.deleteSong(songs[index]);
          }
        });
        this.$('.open').on('click', function() {
          var index, songs;
          songs = view.model.get('data');
          index = $(this).attr('data-index');
          return view.openSong(songs[index]);
        });
        return this;
      },
      openSong: function(song) {
        return Backbone.history.navigate('../../songs/' + song._id + '/edit', {
          trigger: true
        });
      }
    });
    return EditSongsView;
  });

}).call(this);

/*
//@ sourceMappingURL=edit-songs-view.js.map
*/