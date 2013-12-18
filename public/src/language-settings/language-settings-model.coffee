define [
  'backbone'
], (Backbone) ->
  LanguageSettingsModel = Backbone.Model.extend(
    defaults:
      enableLogging: false

    initialize: () ->
      fetchLanguages = () =>
        this.fetchLanguages()
      setTimeout(fetchLanguages, 50)

      this.listenTo(this, 'change:toLanguage', () =>
        callback = (languages) =>
          toLanguage = this.get('toLanguage')
          fromLanguages = this.filterLanguages(languages, toLanguage)
          fromLanguage = this.get('fromLanguage')
          selectedFromLanguage = this.selectLanguage(fromLanguages, fromLanguage)
          
          if this.get('enableLogging')
            console.log('LANGUAGE SETTINGS: update fromLanguages and fromLanguage: ' + selectedFromLanguage)

          this.set(
            fromLanguages: fromLanguages
            fromLanguage: selectedFromLanguage.id
          )

        this.getLanguages(callback)
      )

    fetchLanguages: () ->
      if this.get('enableLogging')
        console.log('LANGUAGE SETTINGS: retrieved')
      
      callback = (languages) =>
        # check to and from languages exist in options, otherwise, change to 0
        toLanguages = languages
        toLanguage = this.get('toLanguage')

        selectedToLanguage = this.selectLanguage(toLanguages, toLanguage)

        fromLanguages = this.filterLanguages(languages, selectedToLanguage.id)
        fromLanguage = this.get('fromLanguage')
        selectedFromLanguage = this.selectLanguage(fromLanguages, fromLanguage)

        this.set(
          toLanguages: toLanguages
          fromLanguages: fromLanguages
          toLanguage: selectedToLanguage.id
          fromLanguage: selectedFromLanguage.id
        )

      this.getLanguages(callback)

    filterLanguages: (languages, filter) ->
      result = []
      for language in languages
        if language.id isnt filter
          result.push(language)

      return result

    # sets the selected field on the language to select if it exists
    # otherwise it sets it on the first language.
    # returns: the language selected, or null if no langauges
    selectLanguage: (languages, toSelect) ->
      if not languages or languages.length is 0
        return null

      selectedLanguage = null
      for language in languages
        if language.id is toSelect
          selectedLanguage = language
        else
          language.selected = false

      if not selectedLanguage?
        selectedLanguage = languages[0]

      selectedLanguage.selected = true
      return selectedLanguage

    getLanguages: (callback) ->
      en =
        id: 'en'
        label: 'EN'
      es =
        id: 'es'
        label: 'ES'
      fr =
        id: 'fr'
        label: 'FR'

      callback([en,es,fr])
  )

  return LanguageSettingsModel