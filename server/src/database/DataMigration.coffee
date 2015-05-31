
class DataMigration
  constructor: ->
    @placeDao = depend('dao/place')

  run: ->
    @initVotes()
    @initZipCode()

  initVotes: ->
    where = (query) ->
      query.whereNull('upvote_count').orWhereNull('downvote_count')

    @placeDao.modifyMulti where, (place) ->
      place.upvote_count = 0
      place.downvote_count = 0

  initZipCode: ->

provide.class(DataMigration)
