require "quadkey_converter/version"

module QuadkeyConverter
  EarthRadius = 6378137.0
  MinLatitude = -85.05112878
  MaxLatitude = 85.05112878
  MinLongitude = -180.0
  MaxLongitude = 180.0

  def self.clip(n, minValue, maxValue)
    [[n, minValue].max, maxValue].min
  end

  def self.mapSize(detail)
    256 << detail.to_i
  end

  def self.locationToQuadkey(location, detail)
    pixel = locationToPixel(location, detail)
    tile = pixelToTile(pixel)

    tileToQuadkey(tile, detail)
  end

  def self.pixelToTile(pixel)
    {x: (pixel[:x] / 256), y: (pixel[:y] / 256)}
  end

  def self.tileToQuadkey(tile, detail)
    out = ""
    detail.downto(0) do |i|
      digit = "0"
      value = digit.ord
      mask = 1 << ( i - 1 )

      value += 1 if ((tile[:x] & mask) != 0)        
      value += 2 if ((tile[:y] & mask) != 0)

      out += value.chr
    end

    return out
  end

  def self.locationToPixel(coord, detail)
    lat = clip(coord[:lat], MinLatitude, MaxLatitude)
    lng = clip(coord[:lng], MinLongitude, MinLatitude)
    x = (lng + 180.0) / 360.0
    sinLat = Math.sin(lat * Math::PI / 180.0)
    y = 0.5 - Math.log((1.0 + sinLat) / (1.0 - sinLat)) / (4.0 * Math::PI)
    size = mapSize(detail).to_f
    pixelX = (clip(x * size + 0.5, 0, size - 1.0)).to_i
    pixelY = (clip(y * size + 0.5, 0, size - 1.0)).to_i

    return {x: pixelX, y: pixelY}
  end
end
