# Karma configuration
# Generated on Sun Nov 02 2014 14:44:14 GMT-0700 (US Mountain Standard Time)

module.exports = (config) ->
  config.set

  # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: ''


  # frameworks to use
  # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine']


  # list of files / patterns to load in the browser
    files: [
      'www/lib/angular/angular.js',
      'www/lib/angular-animate/angular-animate.js',
      'www/lib/angular-cookies/angular-cookies.js',
      'www/lib/angular-mocks/angular-mocks.js',
      'www/lib/angular-sanitize/angular-sanitize.min.js',
      'www/lib/angular-routes/angular-route.min.js',
      'www/lib/angular-touch/angular-touch.min.js',
      'www/lib/angular-permission/dist/angular-permission.js',
      'www/lib/angular-ui-router/release/angular-ui-router.js',
      'www/lib/ngCordova/dist/ng-cordova.js',
      'www/lib/angular-google-maps/dist/angular-google-maps.min.js',
      'www/lib/ionic/js/ionic.js',
      'www/lib/ionic/js/ionic-angular.min.js',
      'www/lib/angular-carousel/dist/angular-carousel.js',
      'www/lib/geolib/dist/geolib.js',
      'test/BootstrapUserApp.coffee',
      'www/lib/userapp/userapp.client.js',
      'www/lib/userapp-angular/angularjs.userapp.js',
      'src/**/*.coffee'
      'test/**/*.spec.coffee',
    ]


  # list of files to exclude
    exclude: [
    ]


  # preprocess matching files before serving them to the browser
  # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      '**/*.coffee': ['coffee']
    }


  # test results reporter to use
  # possible values: 'dots', 'progress'
  # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress']


  # web server port
    port: 9876


  # enable / disable colors in the output (reporters and logs)
    colors: true


  # level of logging
  # possible values:
  # - config.LOG_DISABLE
  # - config.LOG_ERROR
  # - config.LOG_WARN
  # - config.LOG_INFO
  # - config.LOG_DEBUG
    logLevel: config.LOG_INFO


  # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true


  # start these browsers
  # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['PhantomJS']


  # Continuous Integration mode
  # if true, Karma captures browsers, runs the tests and exits
    singleRun: false