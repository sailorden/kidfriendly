
Promise = require('bluebird')

Database =
  randomId: (range = 100000000) ->
    Math.floor(Math.random() * range)

  insertSourceVersion: (app, gitCommit) ->
    new Promise (resolve, reject) =>
      data =
        sha1: gitCommit.sha1
        commit_date: gitCommit.timestamp
        first_deployed_at: DateUtil.timestamp()

      app.db.query 'select id from source_version where sha1=?', [data.sha1], (err, result) ->
        if result.length > 0
          resolve(result[0].id)
          return

        app.db.query 'insert ignore into source_version set ?; select id from source_version where sha1=?', \
          [data, data.sha1], (err, result) ->
            resolve(result[1][0].id)

  writeRow: (app, table, data, {generateId} = {}) ->
    new Promise (resolve, reject) ->
      send = (attempts) ->
        if generateId
          data.id = Database.randomId()

        app.db.query "INSERT INTO #{table} SET ?", data, (err, result) =>

          if generateId and err? and err.code == 'ER_DUP_ENTRY' and attempts < 5
            send(attempts + 1)
          else if err?
            resolve(error: err)
          else
            resolve(id: data.id)

      send(0)
