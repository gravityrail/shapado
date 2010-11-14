class Bounty
  include Mongoid::Document

  identity :type => String

  field :started_at, :type => Time, :default => Time.now
  field :ends_at, :type => Time

  field :active, :type => Boolean, :default => true
  field :reputation, :type => Integer

  validates_presence_of :reputation
  validates_presence_of :started_at
  validates_inclusion_of :reputation, :in => (50..500)

  protected
end
