(function() {
  define(['media.item.view', 'backbone', 'handlebars', 'jquery.ui.sortable', 'templates'], function(MediaItemView, Backbone, Handlebars) {
    var MediaItemListView;
    MediaItemListView = Backbone.View.extend({
      className: "mediaItemList",
      initialize: function(options) {
        var _this = this;
        this.options = options;
        this.listenTo(this.model, 'change', function() {
          var i, newItems, noChange, oldIds, _i, _ref, _ref1, _ref2;
          newItems = _this.model.get('data');
          oldIds = [];
          _this.$('li').each(function() {
            return oldIds.push($(this).attr('data-id'));
          });
          noChange = true;
          if (newItems.length === oldIds.length) {
            for (i = _i = 0, _ref = newItems.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
              if (((_ref1 = newItems[i]) != null ? (_ref2 = _ref1.song) != null ? _ref2._id : void 0 : void 0) !== (oldIds != null ? oldIds[i] : void 0)) {
                noChange = false;
                break;
              }
            }
          } else {
            noChange = false;
          }
          if (noChange) {
            return;
          }
          _this.initItemViews(newItems);
          return _this.render();
        });
        this.listenTo(this.model, 'change:isLoading', function() {
          return _this.render();
        });
        return this.initItemViews(this.model.get('data'));
      },
      render: function() {
        var i, ids, links, options, renderData, sortableList, view, _i, _ref,
          _this = this;
        if (this.model.get('isLoading')) {
          this.$el.html(Handlebars.templates['spinner']());
        } else {
          if (this.mediaItemViews.length > 0) {
            renderData = {
              mediaItems: this.mediaItems,
              hasMoreItems: this.hasMoreItems
            };
            if (this.options.readonly) {
              this.$el.html(Handlebars.templates['media-item-list-readonly'](renderData));
            } else {
              this.$el.html(Handlebars.templates['media-item-list'](renderData));
            }
            links = this.$('.mediaItemLink');
            for (i = _i = 0, _ref = links.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
              $(links[i]).html(this.mediaItemViews[i].render().el);
            }
            view = this;
            this.$('.mediaItemLink').on('click', function(event) {
              var data, index, li;
              data = view.model.get('data');
              li = $(this).parent('li');
              index = li.attr('data-index');
              return view.trigger('select', data[index]);
            });
            if (this.options.allowActions) {
              this.$('.remove').on('click', function(event) {
                var data, index;
                data = view.model.get('data');
                index = $(this).parent('li').attr('data-index');
                return view.trigger('remove', data[index]);
              });
              this.$('.view').on('click', function(event) {
                var data, index;
                data = view.model.get('data');
                index = $(this).parent('li').attr('data-index');
                return view.trigger('view', data[index]);
              });
              this.$('.remove').show();
              this.$('.view').show();
            } else {
              this.$('.remove').hide();
              this.$('.view').hide();
            }
          } else {
            this.$el.html(Handlebars.templates['no-items']());
          }
        }
        if (this.options.allowReorder) {
          sortableList = this.$('ul');
          ids = [];
          this.$('li').each(function() {
            return ids.push($(this).attr('data-id'));
          });
          options = {
            update: function(event, ui) {
              ids = [];
              _this.$('li').each(function() {
                return ids.push($(this).attr('data-id'));
              });
              return _this.trigger('reorder', ids);
            }
          };
          sortableList.sortable(options);
          sortableList.disableSelection();
        }
        return this;
      },
      initItemViews: function(data) {
        var index, item, mediaItemView, numItems, _i, _ref, _results;
        this.hasMoreItems = false;
        this.mediaItemViews = [];
        this.mediaItems = [];
        if (data && data.length > 0) {
          numItems = data.length;
          if (this.options.limit) {
            numItems = Math.min(this.options.limit, data.length);
            if (data.length > this.options.limit) {
              this.hasMoreItems = true;
            }
          }
          _results = [];
          for (index = _i = 0, _ref = numItems - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; index = 0 <= _ref ? ++_i : --_i) {
            item = data[index];
            mediaItemView = new MediaItemView({
              model: new Backbone.Model({
                data: item
              })
            });
            this.mediaItemViews.push(mediaItemView);
            _results.push(this.mediaItems.push(item));
          }
          return _results;
        }
      }
    });
    return MediaItemListView;
  });

}).call(this);

/*
//@ sourceMappingURL=media-item-list-view.js.map
*/