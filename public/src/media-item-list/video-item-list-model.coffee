define [
  'backbone'
], (Backbone) ->
  VideoItemListModel = Backbone.Model.extend(

    initialize: () ->
      songListModel = new Backbone.Model()

      this.listenTo(this, 'change:rawData', () =>
        rawData = this.get('rawData')
        data = []
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
          data: data
        )
      )
  )

  return VideoItemListModel