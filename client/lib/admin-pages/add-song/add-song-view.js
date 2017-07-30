(function() {
  define(['backbone', 'media.item.list.view'], function(Backbone, SongListView) {
    var AddSongView;
    AddSongView = Backbone.View.extend({
      tagName: "div",
      className: "addSong",
      initialize: function() {
        var _this = this;
        this.acView = new SongListView({
          model: this.model
        });
        this.acView.on('select', function(suggestion) {
          _this.model.set({
            songs: [],
            showAC: false
          });
          _this.$('.search').val('');
          return _this.model.trigger('select', suggestion);
        });
        return this.listenTo(this.model, 'change:showAC', function() {
          if (_this.model.get('showAC')) {
            return _this.$('.acContainer').show();
          } else {
            return _this.$('.acContainer').hide();
          }
        });
      },
      render: function() {
        var _this = this;
        this.$el.html(Handlebars.templates['add-song']());
        this.$('.acContainer').html(this.acView.render().el);
        this.$('.search').on('keyup', function() {
          return _this.search();
        });
        this.$('.search').on('focus', function() {
          var fn;
          fn = function(event) {
            var target;
            target = $(event.target);
            if (target.parents('.addSong').length === 0) {
              _this.model.set({
                showAC: false
              });
              return $(window).unbind('click', fn);
            }
          };
          return $(window).on('click', fn);
        });
        return this;
      },
      search: function() {
        var delayedFn, query,
          _this = this;
        query = this.$('.search').val().trim();
        console.log('Prepare to do search: ' + query);
        this.lastSearch = query;
        delayedFn = function() {
          if (query !== _this.lastSearch) {
            return;
          }
          return _this.model.search(query);
        };
        return setTimeout(delayedFn, 50);
      }
    });
    return AddSongView;
  });

}).call(this);

/*
//@ sourceMappingURL=add-song-view.js.map
*/