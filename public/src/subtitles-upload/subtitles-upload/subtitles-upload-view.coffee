define [
  'backbone',
  'subtitles.insert.text.view',
  'subtitles.sync.view',
  'handlebars',
  'templates'
], (Backbone, SubtitlesInsertTextView, SubtitlesSyncView, Handlebars) ->

  SubtitlesUploadView = Backbone.View.extend(
    tagName:  "div"
    className: "upload"

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-upload'](this.model.toJSON()))

      this.$('.uploadOriginal').on('click', () =>
        this.showUploadOriginalStage()
      )
      this.$('.sync').on('click', () =>
        this.showSyncStage()
      )
      this.$('.uploadTranslation').on('click', () =>
        this.showUploadTranslationStage()
      )

      this.showUploadOriginalStage()
      
      return this

    showUploadOriginalStage: () ->
      model = new Backbone.Model(
        subtitles: this.model.get('subtitles').original
      )
      subtitlesUploadOriginalView = new SubtitlesInsertTextView(
        model: model
        title: 'Upload Original'
      )

      subtitlesUploadOriginalView.on('save', (subtitles) =>
        this.saveOriginal(subtitles)
      )

      this.$('.uploadStage').html(subtitlesUploadOriginalView.render().el)

    showUploadTranslationStage: () ->
      model = new Backbone.Model(
        subtitles: this.model.get('subtitles').translation
      )
      subtitlesUploadTranslatedView = new SubtitlesInsertTextView(
        model: model
        title: 'Upload Translation'
      )

      subtitlesUploadTranslatedView.on('save', (subtitles) =>
        this.saveTranslation(subtitles)
      )

      this.$('.uploadStage').html(subtitlesUploadTranslatedView.render().el)

    showSyncStage: () ->
      subtitlesSyncView = new SubtitlesSyncView(
        model: this.model
      )

      subtitlesSyncView.on('save', (subtitles) =>
        this.saveSync(subtitles)
      )

      this.$('.uploadStage').html(subtitlesSyncView.render().el)

    saveOriginal: (originalSubtitles) ->
      this.showSpinner()

      this.model.saveOriginal(originalSubtitles, () =>
        this.showUploadTranslationStage()
      )
    
    saveTranslation: (translatedSubtitles) ->
      this.showSpinner()

      this.model.saveTranslation(translatedSubtitles, () =>
        this.showSyncStage()
      )

    saveSync: (subtitles) ->
      this.showSpinner()

      this.model.saveSync(subtitles, () =>
        this.hideSpinner()
      )

    showSpinner: () ->
      spinner = Handlebars.templates['spinner']()
      this.$('.uploadStage').html(spinner)

    hideSpinner: () ->
      this.$('.uploadStage').html('')

  )

  return SubtitlesUploadView