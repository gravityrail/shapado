include Nominatim
module GeoCommon
  def self.included(base)
    base.class_eval do
      #before_validation_on_create :set_address
      key :address, Hash
      key :position, GeoPosition, :default => GeoPosition.new(0, 0)
      ensure_index [[:position, Mongo::GEO2D]]
    end
  end
  def set_address
    ## TODO execute with magent
    lat = self["position"].lat
    long = self["position"].long
    if lat != 0 || long != 0
      self["address"] = Nominatim::Place.new(lat, long).get_address
      self.save
    end
  end

  def address_name
    address = if self.address != { }

                "#{self.address["city"]}, #{self.address["country"]}" unless self.address["city"].blank?
                self.address["country"]
              else
                I18n.t('global.unknown_place')
              end
  end
end
