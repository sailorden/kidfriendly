'use strict'
angular.module('Mobile', ['ionic', 'config', 'kf.shared', 'ngCordova', 'ngTouch', 'angular-carousel', 'uiGmapgoogle-maps', 'permission'])
.run ($ionicPlatform, $state, $ionicHistory, analyticsService, Permission, userService, $rootScope) ->
  attemptedRoute = undefined

  Permission.defineRole 'authenticated', (stateParams) -> userService.user.isAuthenticated()
  analyticsService.initAndTrackPages()
  userService.getUser().then (user) => analyticsService.setUser(user.id) if user.isAuthenticated()

  $rootScope.$on '$stateChangePermissionDenied', (event, toState, toParams) ->
    attemptedRoute =
      route: toState
      params: toParams
    $state.go 'login'

  $rootScope.$on '$authenticationSuccess', (user)->
    analyticsService.setUser(user.id)
    analyticsService.trackEvent("Auth", "SignIn", "Success")
    $ionicHistory.clearCache()
    if attemptedRoute?
      $ionicHistory.currentView($ionicHistory.backView());
      $state.transitionTo  attemptedRoute.route.name, attemptedRoute.params
      attemptedRoute = undefined

  $ionicPlatform.ready ->
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
    if(window.cordova && window.cordova.plugins.Keyboard)
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)

    if(window.StatusBar)
      # org.apache.cordova.statusbar required
      StatusBar.styleDefault()

.config ($stateProvider, $urlRouterProvider, resolvers, uiGmapGoogleMapApiProvider, $ionicConfigProvider, $provide, $httpProvider) ->
  $ionicConfigProvider.views.swipeBackEnabled(false)
  uiGmapGoogleMapApiProvider.configure
    key: 'AIzaSyC0wntPebMoKnIwbpa82NzLPbwEIlvZvlM'
    v: '3.17'
    libraries: 'weather,geometry,visualization'

  $httpProvider.interceptors.push 'myHttpInterceptor'

  $provide.decorator '$exceptionHandler', ['$delegate', ($delegate) ->
    return (exception, cause) ->
      $delegate(exception, cause)
      if(exception)
        console.log exception
        data = {}
        data.message = exception.message if exception.message?
        data.name = exception.name if exception.name?
        data.stack = exception.stack if exception.stack?
        window.analytics.trackException(data, false)
  ]

  $stateProvider
  .state 'search',
    url: '/search/:keyword'
    templateUrl: 'templates/search-results.html'
    controller: 'SearchCtrl'
    resolve:
      results: resolvers.results

  .state 'login',
    url: '/login'
    templateUrl: 'templates/login.html'

  .state 'signup',
    url: '/signup'
    templateUrl: 'templates/signup.html'

  .state 'start',
    url: '/start'
    templateUrl: 'templates/start.html'
    controller: 'StartCtrl'
    resolve:
      position: resolvers.position

  .state 'review',
    url: '/review/:placeId'
    templateUrl: 'templates/review.html'
    controller:'ReviewCtrl'
    data: {
      permissions: {
        only: ['authenticated']
        redirectTo: 'login'
      }
    }

  .state 'details',
    url:'/details/:placeId/review/:vote'
    templateUrl: 'templates/details.html'
    resolve:
      place: resolvers.place
    controller:'DetailsCtrl'

  .state 'thankyou',
    url:'/thankyou'
    templateUrl: 'templates/review-thankyou.html'
    controller:'DetailsCtrl'

  $urlRouterProvider.otherwise('/start')