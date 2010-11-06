class NotificationConfig
  include Mongoid::Document

  identity :type => String

  field :give_advice, :type => Boolean, :default => true
  field :activities, :type => Boolean, :default => true
  field :reports, :type => Boolean, :default => true
  field :new_answer, :type => Boolean, :default => true
end
