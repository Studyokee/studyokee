define [
  'dictionary.view',
  'youtube.main.view',
  'media.item.list.view',
  'backbone',
  'handlebars',
  'templates'
], (DictionaryView, MainView, MenuView, Backbone, Handlebars) ->
  ClassroomView = Backbone.View.extend(
    tagName:  "div"
    className: "classroom"
    
    initialize: () ->
      this.mainView = new MainView(
        model: this.model.mainModel
      )
      this.menuView = new MenuView(
        model: this.model.menuModel
        allowSelect: true
      )

      this.dictionaryView = new DictionaryView(
        model: this.model.dictionaryModel
      )

      this.mainView.on('lookup', (query) =>
        this.model.lookup(query)
      )
      
      this.mainView.on('enterPresentationMode', () =>
        $('body').addClass('presentation-mode')
      )
      this.mainView.on('leavePresentationMode', () =>
        $('body').removeClass('presentation-mode')
      )

      this.listenTo(this.model, 'change', () =>
        this.render()
      )

      this.menuView.on('select', (item) =>
        this.model.mainModel.trigger('changeSong', item.song)
      )

    render: () ->
      this.$el.html(Handlebars.templates['classroom'](this.model.toJSON()))

      this.$('.mediaItemListContainer').html(this.menuView.render().el)
      this.$('.center').html(this.mainView.render().el)
      this.$('.dictionaryContainer').html(this.dictionaryView.render().el)

      return this
  )

  return ClassroomView