define [
  'dictionary.view',
  'backbone',
  'handlebars',
  'templates'
], (DictionaryView, Backbone, Handlebars) ->
  HomeView = Backbone.View.extend(
    tagName:  "div"
    className: "home"
    
    initialize: () ->
      this.mainView = this.options.mainView
      this.menuView = this.options.menuView

      this.dictionaryView = new DictionaryView(
        model: this.model.dictionaryModel
      )

      this.on('lookup', (query) =>
        this.model.lookup(query)
        this.$('.dictionaryContainer').addClass('active')

        this.dictionaryView.on('close', () =>
          this.$('.dictionaryContainer').removeClass('active')
        )
      )

      this.on('toggleMenu', () =>
        this.$('.menu').toggleClass('active')
      )
      
      this.mainView.on('enterPresentationMode', () =>
        this.enterPresentationMode()
      )
      this.mainView.on('leavePresentationMode', () =>
        this.leavePresentationMode()
      )

    render: () ->
      this.$el.html(Handlebars.templates['home'](this.model.toJSON()))

      if this.menuView
        this.$('.menu').html(this.menuView.render().el)
      if this.mainView
        this.$('.center').append(this.mainView.render().el)

      this.$('.dictionaryContainer').html(this.dictionaryView.render().el)

      return this

    enterPresentationMode: () ->
      this.$('.center').addClass('presentation-mode')
      this.$('.center .video-player-container').addClass('col-lg-6')
      this.$('.center .player-container').addClass('col-lg-6')
      this.calculateYTPlayerHeight()

    leavePresentationMode: () ->
      this.$('.center').removeClass('presentation-mode')
      this.$('.center .video-player-container').removeClass('col-lg-6')
      this.$('.center .player-container').removeClass('col-lg-6')
      this.calculateYTPlayerHeight()

    calculateYTPlayerHeight: () ->
      ytPlayerWidth = this.$('#ytPlayer').width()
      ytPlayerHeight = ytPlayerWidth * 0.75
      this.$('#ytPlayer').height(ytPlayerHeight + 'px')


  )

  return HomeView