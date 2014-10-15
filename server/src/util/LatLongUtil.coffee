
toRadians = (degrees) ->
  degrees / 180.0 * Math.PI
toDegrees = (radians) ->
  radians / Math.PI * 180

class Vec2
  constructor: (@x, @y) ->
  addX: (x) ->
    new Vec2(@x + x, @y)
  addY: (y) ->
    new Vec2(@x, @y + y)

class Location
  constructor: (@lat, @long) ->
  addLat: (lat) ->
    new Location(@lat + lat, @long)
  addLong: (long) ->
    new Location(@lat, @long + long)

class Square
  isSquare: true
  constructor: (@topLeft, @bottomRight) ->

sort2 = (x, y) ->
  if x > y
    [y, x]
  else
    [x, y]

LatLongUtil =
  earthRadiusMiles: 3959
  areas:
    phoenix: new Square(new Location(33.90, -112.53), new Location(33.19, -111.50))

  latLongDeltaFromDistance: (latLong, distanceMiles) ->
    # Returns a delta (x,y) where, if you start at latLong and travel distanceMiles,
    # the location will be within +/- the delta.
    dlat = distanceMiles / LatLongUtil.earthRadiusMiles
    dlong = Math.asin(Math.sin(dlat) / Math.cos(toRadians(latLong.lat)))
    return {dlat: toDegrees(dlat), dlong: toDegrees(dlong)}

  latticePointsForAreaSimpler: (area, radiusMiles) ->
    if not area.isSquare
      throw new Error("only works on squares")

    output = []
    offsetLong = false
    latLongDelta = LatLongUtil.latLongDeltaFromDistance(area.topLeft, radiusMiles*2)

    rowStart = area.topLeft
    [latStart, latEnd] = sort2(area.topLeft.lat, area.bottomRight.lat)
    [longStart, longEnd] = sort2(area.topLeft.long, area.bottomRight.long)

    for currentLat in [latStart..latEnd] by latLongDelta.dlat
      for currentLong in [longStart..longEnd] by latLongDelta.dlong
        if offsetLong
          currentLong += latLongDelta.dlong / 2
        output.push(new Location(currentLat, currentLong))
      offsetLong = not offsetLong
    return output

exports.LatLongUtil = LatLongUtil
