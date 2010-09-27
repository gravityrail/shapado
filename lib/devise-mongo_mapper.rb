module Devise
  module Orm
    module MongoMapper
      
      module Hook
        def devise_modules_hook!
          extend Schema
          include Compatibility
          yield
          return unless Devise.apply_schema
          devise_modules.each { |m| send(m) if respond_to?(m, true) }
        end
      end
      
      module Schema
        include Devise::Schema
        def apply_devise_schema(name, type, options={})
          type = Time if type == DateTime
          key name, type, options
        end
      end
      
      module Compatibility
       extend ActiveSupport::Concern
         module ClassMethods
           
          def find(*args)
            case args.first
            when :first, :all
              send(args.shift, *args)
            else
              super
            end
          end
        end
      end
    end
  end
end

[MongoMapper::Plugins::Document, MongoMapper::Plugins::EmbeddedDocument].each do |mod|
  mod::ClassMethods.class_eval do
    include Devise::Models
    include Devise::Orm::MongoMapper::Hook
  end
end