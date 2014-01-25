define [
  'backbone'
  'handlebars',
  'media.item.list.view',
  'templates'
], (Backbone, Handlebars, MediaItemListView) ->

  SuggestionsView = Backbone.View.extend(
    tagName:  "div"
    className: "suggestions"

    initialize: () ->
      this.mediaItemListView = new MediaItemListView(
        model: this.model
      )

      this.mediaItemListView.on('select', (item) =>
        this.model.set(
          selectedItem: item
        )
        this.trigger('select', item)
      )

    render: () ->
      this.$el.html(Handlebars.templates['suggestions'](this.model.toJSON()))
      this.$('.mediaItemListContainer').html(this.mediaItemListView.render().el)

      return this
  )

  return SuggestionsView