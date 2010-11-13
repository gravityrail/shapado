class Bounty
  include Mongoid::Document

  identity :type => String

  field :started_at, :type => Time, :default => Time.now
  field :active, :type => Boolean, :default => true
  field :reputation, :type => Integer

  validates_presence_of :reputation
  validates_presence_of :started_at
end
