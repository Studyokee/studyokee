define [
  'backbone',
  'subtitles.insert.text.view',
  'edit.subtitles.view',
  'subtitles.sync.view',
  'handlebars',
  'templates'
], (Backbone, SubtitlesInsertTextView, EditSubtitlesView, SubtitlesSyncView, Handlebars) ->

  SubtitlesUploadView = Backbone.View.extend(
    tagName:  "div"
    className: "upload"

    initialize: () ->
      this.uploadTranslationView = new SubtitlesInsertTextView(
        model: this.model
      )
      this.uploadTranslationView.on('save', (translation) =>
        this.saveTranslation(translation)
      )

      this.editSubtitlesView = new EditSubtitlesView(
        model: this.model
      )
      this.editSubtitlesView.on('save', (original) =>
        this.saveSubtitles(original)
      )

      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['subtitles-upload'](this.model.toJSON()))

      this.$('.translationContainer').html(this.uploadTranslationView.render().el)
      this.$('.subtitlesContainer').html(this.editSubtitlesView.render().el)
      
      return this

    saveTranslation: (translation) ->
      this.showSpinner()

      this.model.saveTranslation(translation, () =>
        this.hideSpinner()
      )

    saveSubtitles: (original) ->
      this.showSpinner()

      this.model.saveSubtitles(original, () =>
        this.hideSpinner()
      )


    # showSyncStage: () ->
    #   subtitlesSyncView = new SubtitlesSyncView(
    #     model: this.model
    #   )

    #   subtitlesSyncView.on('save', (subtitles) =>
    #     this.saveSync(subtitles)
    #   )

    #   this.$('.uploadStage').html(subtitlesSyncView.render().el)
    
    # saveSync: (subtitles) ->
    #   this.showSpinner()

    #   this.model.saveSync(subtitles, () =>
    #     this.hideSpinner()
    #   )

    showSpinner: () ->
      spinner = Handlebars.templates['spinner']()
      this.$('.uploadStage').html(spinner)

    hideSpinner: () ->
      this.$('.uploadStage').html('')

  )

  return SubtitlesUploadView