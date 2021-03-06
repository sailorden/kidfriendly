module.exports = configs =
  services:
    forever:
      adminPort: 3500
    postgres:
      host: '/tmp'
      debugConnection: process.env.KFLY_DEBUG_DATABASE ? false
      database: process.env.KFLY_DATABASE ? 'kidfriendly'

  apps:
    web:
      adminPort: 3501
      express:
        port: 3000
      
      roles:
        dbMigration: {}

    ghost:
      main: 'index.js'
      foreverOptions:
        uid: 'ghost'
        cwd: '/ghost'
        options: ['--production']
        env:
          NODE_ENV: 'production'

configs.currentFeatures = []

configs.schema = require('./schema')
