define [
  'backbone'
], (Backbone) ->
  MediaItemListModel = Backbone.Model.extend(

    initialize: () ->
      songListModel = new Backbone.Model()
      this.set(
        isLoading: true
      )

      this.listenTo(this, 'change', () =>
        console.log('test')
        rawData = this.get('rawData')
        data = []

        if rawData
          for item in rawData
            icon = ''
            if item.videoSnippet?
              icon = item.videoSnippet.snippet?.thumbnails?.medium.url
            
            item =
              song: item.song
              title: item.song.metadata?.trackName
              description: item.song.metadata?.artist
              icon: icon
              
            data.push(item)
        
        this.set(
          isLoading: false
          data: data
        )
      )
  )

  return MediaItemListModel