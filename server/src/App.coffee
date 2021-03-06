
path = require('path')
Promise = require('bluebird')

global.InternalError = (err) ->
  console.log("[internal error] #{err} #{err.stack ? ""}")

class App
  constructor: ->
    @config = depend('Configs')
    @devMode = process.env.KFLY_DEV_MODE

    @appConfig = @config.appConfig

    # During startup we log to stdout, so that any problems are captured in Forever logs.
    # After startup is finished, we switch to the app log file.
    @log = console.log

    if @devMode
      @debugLog = console.log
    else
      @debugLog = ->

    @handlers = null
    @sourceVersion = null
    @currentGitCommit = null
    @sourceUtil = null
    @db = null
    @express = null
    @startedAt = Date.now()

    @adminPort = null

  start: ->
    Promise.resolve()
      .then(@postgresSetup)
      .then(@schemaMigration)
      .then(@initializeSourceVersion)
      .then(@setupAdminPort)
      .then(@setupPub)
      .then(@startExpress)
      .then(@finishStartup)
      .catch (err) =>
        if err?.stack?
          @log(err?.stack)
        else
          @log(err)

  postgresSetup: =>
    @postgresClient = depend('PostgresClient')
    @postgresClient.connect()
    .then =>
      @db = @postgresClient.knex
      @insert = @postgresClient.insert

  schemaMigration: =>
    if @config.appConfig.roles?.dbMigration?
      @postgresClient.sqlMigrate()

  fetchCurrentGitVersion: =>
    SourceUtil.getCurrentGitCommit()
      .then (info) =>
        @currentGitCommit = info

  initializeSourceVersion: =>
    if not @db?
      @log("skipping source version init (no DB)")
      return

    @sourceUtil = depend('SourceUtil')
    @sourceUtil.insertSourceVersion()
      .then (id) =>
        @sourceVersion = id
        @log("current source version is:", id)

  setupAdminPort: =>
    @log("listening on admin port: " + @config.appConfig.adminPort)
    AdminPort = depend('AdminPort')
    @adminPort = AdminPort(@config.appConfig.adminPort)

  startExpress: =>
    if not @config.appConfig.express?
      return

    ExpressServer = depend('ExpressServer')
    @expressServer = new ExpressServer(this, @config.appConfig.express)
    @expressServer.start()

  finishStartup: =>
    depend('NightlyTasks')

    duration = Date.now() - @startedAt
    @log("Server startup completed (in #{duration} ms)")

startApp = (appName = 'web') ->
  console.log('Launching app: '+appName)

  try
    # Try to setuid() to a user matching the app name. Only expected to work when running
    # on a server (not locally)
    user = appName + '-app'
    process.setuid(user)
    console.log("setuid() successful with: "+user)
    process._successfulSetuidUser = user

  # Change directory to top-level, one above the 'server' dir. (such as /kfly)
  dir = path.resolve(path.join(__dirname, '../..'))

  process.chdir(dir)
  console.log('current directory is now: ' + dir)

  config = require('./../config')

  if not config.apps[appName]?
    throw new Error("service name not found in config: "+appName)

  config.appName = appName
  config.appConfig = config.apps[appName]

  provide('Configs', -> config)
  app = new App(config)
  provide('App', -> app)
  app.start()

exports.startApp = startApp
