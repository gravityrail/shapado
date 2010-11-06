class GeoPosition
  attr_reader :lat, :long

  def self.to_mongo(value)
    return if value.nil?
    if value.is_a?(self)
      {'lat' => Float.to_mongo(value.lat), 'long' => Float.to_mongo(value.long)}
    elsif value.is_a?(Hash)
      value
    end
  end

  def self.from_mongo(value)
    return if value.nil?

    value.is_a?(self) ? value : GeoPosition.new(value['lat'], value['long'])
  end

  def initialize(lat, long)
    @lat, @long = Float.to_mongo(lat), Float.to_mongo(long)
  end

  def [](arg)
    case arg
    when "lat"
      @lat
    when "long"
      @long
    end
  end

  def to_a
    [lat, long]
  end

  def ==(other)
    other.is_a?(self.class) && other.lat == lat && other.long == long
  end
end
