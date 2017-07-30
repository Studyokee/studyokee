(function() {
  define(['media.item.list.view', 'create.song.view', 'backbone', 'handlebars', 'templates'], function(MediaItemList, CreateSongView, Backbone, Handlebars) {
    var EditClassroomView;
    EditClassroomView = Backbone.View.extend({
      initialize: function() {
        var _this = this;
        this.songListView = new MediaItemList({
          model: this.model.songListModel,
          allowReorder: true,
          allowActions: true
        });
        this.createSongView = new CreateSongView({
          model: this.model.createSongModel
        });
        this.songSearchListView = new MediaItemList({
          model: this.model.songSearchListModel
        });
        this.listenTo(this.model, 'change', function() {
          return _this.render();
        });
        this.songSearchListView.on('select', function(item) {
          _this.model.addSong(item.song._id);
          _this.model.songSearchListModel.set({
            rawData: []
          });
          _this.$('#searchSongs').val('');
          return _this.$('.songSearchListContainer').hide();
        });
        this.songListView.on('remove', function(item) {
          if (confirm('Remove song from classroom?')) {
            return _this.model.removeSong(item.song._id);
          }
        });
        this.songListView.on('view', function(item) {
          return Backbone.history.navigate('/songs/' + item.song._id + '/edit', {
            trigger: true
          });
        });
        this.songListView.on('reorder', function(ids) {
          return _this.model.saveSongs(ids);
        });
        this.createSongView.on('saveSuccess', function(song) {
          _this.$('.addNewSongModal').hide();
          return _this.model.addSong(song._id);
        });
        return this.createSongView.on('cancel', function(song) {
          return _this.$('.addNewSongModal').hide();
        });
      },
      render: function() {
        var classroom, language, _ref, _ref1,
          _this = this;
        this.$el.html(Handlebars.templates['edit-classroom'](this.model.toJSON()));
        this.$('.songListContainer').html(this.songListView.render().el);
        this.$('.songSearchListContainer').html(this.songSearchListView.render().el);
        this.$('.addNewSongContainer').html(this.createSongView.render().el);
        if ((_ref = this.model.get('data')) != null ? (_ref1 = _ref.songs) != null ? _ref1.length : void 0 : void 0) {
          this.$('.songCount').html('(' + this.model.get('data').songs.length + ')');
        }
        classroom = this.model.get('data');
        if (classroom != null) {
          language = '';
          switch (classroom.language) {
            case 'es':
              language = 'Spanish';
              break;
            case 'fr':
              language = 'French';
              break;
            case 'de':
              language = 'German';
          }
          this.$('#language').val(language);
        }
        this.$('#searchSongs').keyup(function(event) {
          var query;
          query = _this.$('#searchSongs').val();
          return _this.model.searchSongs(query);
        });
        this.$('#searchSongs').focus(function(event) {
          _this.$('#searchSongs').val('');
          _this.model.clearSongSearch();
          return _this.$('.songSearchListContainer').show();
        });
        this.$('#searchSongs').blur(function(event) {
          if (!_this.$('#searchSongs').val()) {
            return _this.$('.songSearchListContainer').hide();
          }
        });
        this.$('.addNewSong').on('click', function() {
          _this.$('.addNewSongModal').show();
          return _this.$('.addNewSongModal .modal').show();
        });
        this.$('.closeAddSongModal').on('click', function() {
          return _this.$('.addNewSongModal').hide();
        });
        this.$('.viewClassroom').on('click', function(e) {
          var _ref2;
          Backbone.history.navigate('classrooms/' + ((_ref2 = _this.model.get('data')) != null ? _ref2.classroomId : void 0), {
            trigger: true
          });
          return e.preventDefault();
        });
        this.$('.deleteClassroom').on('click', function(event) {
          if (confirm('Are you sure you want to delete this classroom?')) {
            _this.model.deleteClassroom(_this.model.get('data'));
            Backbone.history.navigate('/', {
              trigger: true
            });
            return event.preventDefault();
          }
        });
        this.$('.classroomTitle').click(function() {
          $('.classroomTitle').hide();
          return $('.editClassroomTitle').show();
        });
        this.$('.editClassroomTitle').on('blur', function() {
          var name;
          name = $('.editClassroomTitle').val();
          if (!name) {
            return;
          }
          _this.model.saveClassroom(name);
          $('.classroomTitle').text(name).show();
          return $('.editClassroomTitle').hide();
        });
        return this;
      }
    });
    return EditClassroomView;
  });

}).call(this);

/*
//@ sourceMappingURL=edit-classroom-view.js.map
*/