'use strict'
class PlacesService
  constructor:(@$http, @$q, @$timeout, @locationService)->

  search:(keyword, position) ->
    deferred = @$q.defer()
    @$http.get("http://kidfriendlyreviews.com/api/search/nearby?type=restaurant&lat=#{position.coords.latitude}&long=#{position.coords.longitude}&keyword=#{keyword}").success (data) =>
      @searchResults = data
      console.log data
      for result in @searchResults
        result.distance = @locationService.calculateDistance position.coords,
          latitude:parseFloat result.lat, 10
          longitude:parseFloat result.long, 10
        result.distance = Math.round(result.distance * 10 *1.5) / 10
      deferred.resolve(@searchResults)
    deferred.promise

  getPlace: (id) ->
    return result for result in @searchResults when result.place_id == id
    return null

  getPlaceDetail:(id) ->
    deferred = @$q.defer()
    @$http.get("http://kidfriendlyreviews.com/api/place/#{id}/details").success (data) =>
      @currentPlace = data
      deferred.resolve(data)
    deferred.promise

  getCurrentPlace:->
    @currentPlace

  submitReview: (userId, placeId, review) ->
    deferred = @$q.defer()
    @$http.post("http://kidfriendlyreviews.com/api/user/#{userId}/place/#{placeId}/review", review)
    .success (data) =>
      deferred.resolve()
    .error (error) =>
      deferred.reject("Error saving review")

PlacesService.$inject = ['$http', '$q', '$timeout', 'locationService']
angular.module('kf.shared').service 'placesService', PlacesService