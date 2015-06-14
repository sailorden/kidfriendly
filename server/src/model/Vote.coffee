
class Vote

  @table:
    name: 'user_vote'

  @fields:
    user_id:
      type: 'id'
    place_id:
      type: 'id'
    vote:
      type: 'integer'

provide('dao/vote', -> depend('newDAO')(Vote))
