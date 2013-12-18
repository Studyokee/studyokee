define [
  'backbone'
], (Backbone) ->
  LanguageSettingsView = Backbone.View.extend(
    tagName:  "div"
    className: "languageSettings"

    initialize: () ->
      this.listenTo(this.model, 'change', () =>
        this.render()
      )

    render: () ->
      this.$el.html(Handlebars.templates['language-settings'](this.model.toJSON()))

      toLanguage = this.model.get('toLanguage')
      toSelect = this.$('.toLanguage option').filter(() ->
        return $(this).val() is toLanguage
      )
      toSelect.prop('selected', true)

      fromLanguage = this.model.get('fromLanguage')
      toSelect = this.$('.fromLanguage option').filter(() ->
        return $(this).val() is fromLanguage
      )
      toSelect.prop('selected', true)

      this.$('.toLanguage').on('change', (e) =>
        newValue = e.currentTarget.selectedOptions[0].value
        if this.model.get('enableLogging')
          console.log('LANGUAGE SETTINGS: updated to: ' + newValue)
        this.model.set(
          toLanguage: newValue
        )
      )
      this.$('.fromLanguage').on('change', (e) =>
        newValue = e.currentTarget.selectedOptions[0].value
        if this.model.get('enableLogging')
          console.log('LANGUAGE SETTINGS: updated to: ' + newValue)
        this.model.set(
          fromLanguage: newValue
        )
      )

      return this
  )

  return LanguageSettingsView