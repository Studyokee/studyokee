(function() {
  define(['media.item.list.view', 'dictionary.view', 'subtitles.scroller.view', 'subtitles.controls.view', 'youtube.player.view', 'backbone', 'handlebars', 'templates'], function(MenuView, DictionaryView, SubtitlesScrollerView, SubtitlesControlsView, YoutubePlayerView, Backbone, Handlebars) {
    var ClassroomView;
    ClassroomView = Backbone.View.extend({
      initialize: function() {
        var _this = this;
        this.menuView = new MenuView({
          model: this.model.menuModel,
          allowSelect: true
        });
        this.subtitlesControlsView = new SubtitlesControlsView({
          model: this.model.youtubePlayerModel
        });
        this.subtitlesScrollerView = new SubtitlesScrollerView({
          model: this.model.subtitlesScrollerModel
        });
        this.youtubePlayerView = new YoutubePlayerView({
          model: this.model.youtubePlayerModel
        });
        this.dictionaryView = new DictionaryView({
          model: this.model.dictionaryModel
        });
        this.listenTo(this.model, 'change:currentSong', function() {
          return _this.render();
        });
        this.menuView.on('select', function(item) {
          console.log('ClassroomView: update current song');
          window.location.hash = '#' + item.title;
          return _this.model.set({
            currentSong: item.song
          });
        });
        this.subtitlesControlsView.on('toggleTranslation', function() {
          return _this.subtitlesScrollerView.trigger('toggleTranslation');
        });
        this.subtitlesScrollerView.on('lookup', function(query) {
          _this.model.dictionaryModel.set({
            query: query
          });
          _this.model.youtubePlayerModel.pause();
          return $('.dictionaryContainerWrapper').show();
        });
        return this.subtitlesScrollerView.on('selectLine', function(i) {
          return _this.model.youtubePlayerModel.jumpTo(i);
        });
      },
      render: function() {
        var user, _ref;
        this.$el.html(Handlebars.templates['classroom'](this.model.toJSON()));
        this.$('.mediaItemListContainer').html(this.menuView.render().el);
        this.$('.video-player-container').html(this.youtubePlayerView.render().el);
        this.$('.player-container').html(this.subtitlesScrollerView.render().el);
        this.$('.controls-container').html(this.subtitlesControlsView.render().el);
        this.$('.dictionaryContainer').html(this.dictionaryView.render().el);
        $('.dictionaryContainerWrapper > .close').click(function() {
          return $('.dictionaryContainerWrapper').hide();
        });
        user = this.model.get('settings').get('user');
        if (user.admin === 'true' || ((_ref = this.model.get('classroom')) != null ? _ref.createdById : void 0) === user.id) {
          $('.editClassroomButton').show();
        }
        return this;
      }
    });
    return ClassroomView;
  });

}).call(this);

/*
//@ sourceMappingURL=classroom-view.js.map
*/