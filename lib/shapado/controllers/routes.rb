module Shapado
  module Controllers
    module Routes
      def self.included(base)
        base.class_eval do
          helper_method :logo_path, :css_group_path, :favicon_group_path
        end
      end

      def logo_path(group)
        "/_files/groups/logo/#{group.id}"
      end

      def css_group_path(group)
        "/_files/groups/css/#{group.id}"
      end

      def favicon_group_path(group)
        "/_files/groups/favicon/#{group.id}"
      end
    end
  end
end