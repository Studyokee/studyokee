define [
  'backbone'
], (Backbone) ->

  RdioSearch = Backbone.Model.extend(

    search: (query, callback) ->
      if not query? or query is ''
        return

      if this.get('settings').get('enableLogging')
        console.log('RdioPlayer: search: ' + query)

      this.set(
        lastSearch: query
      )
      $.ajax(
        type: 'GET'
        url: '/api/rdio/search/' + query
        success: (data) =>
          if query isnt this.get('lastSearch')
            return

          callback(data)
      )
  )

  return RdioSearch