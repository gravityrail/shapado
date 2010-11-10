module Mongoid
  module State
    alias :new? :new_record?
  end
end

module Mongoid
  module Keys
    module ClassMethods
      def key(*args)
        raise ArgumentError, "Attempt to define a field with #{args.inspect}"
      end
    end
  end
end

module Mongoid #:nodoc:
  module Contexts #:nodoc:
    class Mongo
      def process_options
        fields = options[:fields]
        if fields && fields.size > 0 && !fields.include?(:_type)
          if fields.kind_of?(Hash)
            fields[:_type] = 1 if fields.first.last != 0 # Not excluding
          else
            fields << :type
          end
          options[:fields] = fields
        end
        options.dup
      end
    end
  end
end

module MongoFieldsExt
  def only(*args)
    @options[:fields] = {}
    args.flatten.each do |f|
      @options[:fields][f] = 1
    end
    self
  end

  def without(*args)
    @options[:fields] = {}
    args.flatten.each do |f|
      @options[:fields][f] = 0
    end
    self
  end
end

Mongoid::Criteria.send(:include, MongoFieldsExt)

module Mongoid
  module Document
    module ClassMethods
      def without(*args)
        criteria.without(*args)
      end
    end
  end
end

