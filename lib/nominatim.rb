require 'open-uri'
require 'json'

module Nominatim
  class Place
    attr_reader :lat, :long
    def initialize(lat, long)
      @lat = lat
      @long = long
    end

    def get_address
      url = "http://nominatim.openstreetmap.org/reverse?format=json&lat=#{self.lat}&lon=#{self.long}&zoom=18&addressdetails=1"
      data = JSON.parse(open(url).read)
      data["address"]
    end

    def get_address_from_country(country)
      country = country.split(',').first
      url = URI.escape("http://nominatim.openstreetmap.org/search?q=#{country}&format=json&polygon=1&addressdetails=1&limit=1")
      data = JSON.parse(open(url).read)
    end
  end
end
