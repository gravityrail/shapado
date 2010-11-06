class NotificationConfig
  include Mongoid::Document

  key :_id, String

  key :give_advice, Boolean, :default => true
  key :activities, Boolean, :default => true
  key :reports, Boolean, :default => true
  key :new_answer, Boolean, :default => true
end
