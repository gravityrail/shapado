module Shapado
module Models
  module GeoCommon
    extend ActiveSupport::Concern

    included do
      field :address, :type => Hash, :default => {}
      field :position, :type => GeoPosition, :default => GeoPosition.new(0, 0)
      index [[:position, Mongo::GEO2D]]
      scope :near, lambda { |point, opts| {:position => {:$near => point, :$maxDistance => 6}}.merge(opts) }
    end

    module InstanceMethods
      def set_address
        lat = self["position"].lat
        long = self["position"].long
        if lat != 0 || long != 0
          self["address"] = Nominatim::Place.new(lat, long).get_address
          self.save
          if self.user.address != self.address
            self.user.position = self.position
            self.user.address = self.address
            self.user.save
          end
        end
      end

      def address_name
        address = if self.address.present? && self.address != { }
          unless self.address["city"].blank?
            "#{self.address["city"]}, #{self.address["country"]}"
          else
            self.address["country"]
          end
        else
          I18n.t('global.unknown_place')
        end
      end

      def point
        @_point ||= [self.position["lat"], self.position["long"]]
      end
    end
  end
end
end
