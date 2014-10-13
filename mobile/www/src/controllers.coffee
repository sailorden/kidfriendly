'use strict'
mod = angular.module 'Mobile.controllers', []

mod.controller 'DashCtrl', ($scope) ->

mod.controller 'FriendsCtrl', ($scope, Friends) ->
  $scope.friends = Friends.all()

mod.controller 'FriendDetailCtrl', ($scope, $stateParams, Friends) ->
  $scope.friend = Friends.get($stateParams.friendId)

mod.controller 'AccountCtrl', ($scope) ->

mod.controller 'SearchCtrl', ($scope, $state, $location) ->
  $scope.performSearch = ->
    console.log 'click'
    $state.go('results')
#    $location.path '#/results'

mod.controller 'SearchResultsCtrl', ($scope) ->
  $scope.results = [
    {name: "Joe's Pizza", addr: "42 Pizza Way, Scottsdale", distance:".2 mi", thumb: "https://lh4.googleusercontent.com/-9c4TjXE17oM/U7Wd2nY0XpI/AAAAAAAA19I/Fkd6zm0hMsE/w88-h88-p/photo.jpg"}
    {name: "Party Pie", addr: "5447 Thomas Road, Scottsdale ", distance: "1.2 mi", thumb: "https://lh6.googleusercontent.com/-w30do65Me-w/U0RGkDJJsyI/AAAAAAAAq_o/zwuikUyF_6g/w88-h88-p/photo.jpg"}
    {name: "Pizza all The way", addr: "321  Main St Scottsdale", distance: "3 mi", thumb:"https://lh3.googleusercontent.com/-CsA7u0NKdSM/VCXIicXc0hI/AAAAAAABDoc/TaiWHhvbjTU/w88-h88-p/photo.jpg"}
    {name: "Papa Dan's", addr: "1 Pizza Blvd Scottsdale", distance: "3.4 mi", thumb:"https://lh5.googleusercontent.com/-PJkwOSrCtfI/U1fqVCExFyI/AAAAAAAArbQ/8gdHza5_3Bs/w88-h88-p/photo.jpg"}
    {name: "Saucy Slice ", addr: "710 Park Ave Phoenix", distance: "4 mi", thumb:"https://lh3.googleusercontent.com/-yID3u_kWWXs/T6Q8I4aj8ZI/AAAAAAAAAEI/z9BxugJsYLw/w88-h88-p/Domino%27s%2BPizza"}
    {name: "Hello Pizza", addr: "589 Arizona Place Phoenix", "4 mi", thumb:"https://geo0.ggpht.com/cbk?cb_client=maps_sv.tactile&output=thumbnail&thumb=2&panoid=Cnt9Ojd_FCrQqXhZnjbBXg&w=88&h=88&yaw=184&pitch=0&ll=33.500718%2C-111.923294"}
  ]