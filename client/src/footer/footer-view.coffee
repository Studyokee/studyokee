define [
  'backbone',
  'handlebars',
  'templates'
], (Backbone, Handlebars) ->
  FooterView = Backbone.View.extend(
    tagName: 'footer'
    className: 'container'
    
    initialize: () ->

    render: () ->
      this.$el.html(Handlebars.templates['footer'](this.model.toJSON()))

      return this
  )

  return FooterView