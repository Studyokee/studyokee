(function() {
  define(['backbone', 'handlebars', 'templates'], function(Backbone, Handlebars) {
    var PaginationView;
    PaginationView = Backbone.View.extend({
      className: "pagination",
      tagName: "ul",
      initialize: function() {
        var _this = this;
        return this.listenTo(this.model, 'change', function() {
          return _this.render();
        });
      },
      render: function() {
        var count, currentPage, index, li, list, pageCount, pageSize, view, _i, _ref,
          _this = this;
        count = this.model.get('count');
        currentPage = this.model.get('currentPage');
        pageSize = this.model.get('pageSize');
        pageCount = Math.ceil(count / pageSize);
        this.$el.html(Handlebars.templates['pagination'](this.model));
        if (pageCount < 2) {
          this.$el.hide();
          return this;
        } else {
          this.$el.show();
        }
        list = '';
        for (index = _i = 0, _ref = pageCount - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; index = 0 <= _ref ? ++_i : --_i) {
          li = '<li';
          if (index === currentPage) {
            li += ' class="active"';
          }
          li += '><a href="#" class="selectPage">' + (index + 1) + '</a></li>';
          list += li;
        }
        this.$('.prevPage').after(list);
        view = this;
        this.$('.selectPage').on('click', function(event) {
          index = parseInt($(this).html() - 1);
          view.trigger('openPage', index);
          return event.preventDefault();
        });
        if (currentPage === 0) {
          this.$('.prevPage').addClass('disabled');
        } else {
          this.$('.prevPage').on('click', function(event) {
            _this.trigger('openPage', _this.model.get('currentPage') - 1);
            return event.preventDefault();
          });
        }
        if (currentPage === (pageCount - 1)) {
          this.$('.nextPage').addClass('disabled');
        } else {
          this.$('.nextPage').on('click', function(event) {
            _this.trigger('openPage', _this.model.get('currentPage') + 1);
            return event.preventDefault();
          });
        }
        return this;
      }
    });
    return PaginationView;
  });

}).call(this);

/*
//@ sourceMappingURL=pagination-view.js.map
*/