class Membership
  include Mongoid::Document

  ROLES = %w[user moderator owner]

  identity :type => String
  field :display_name, :type => String

  field :group_id, :type => String
  referenced_in :group

  field :reputation, :type => Float, :default => 0.0
  field :profile, :type => Hash # custom user keys

  field :votes_up, :type => Float, :default => 0.0
  field :votes_down, :type => Float, :default => 0.0

  field :views_count, :type => Float, :default => 0.0

  field :preferred_tags, :type => Array

  field :last_activity_at, :type => Time
  field :activity_days, :type => Integer, :default => 0

  field :role, :type => String, :default => "user"

  field :bronze_badges_count,       :type => Integer, :default => 0
  field :silver_badges_count,       :type => Integer, :default => 0
  field :gold_badges_count,         :type => Integer, :default => 0
  field :is_editor,                 :type => Boolean, :default => false

  validates_inclusion_of :role,  :in => ROLES
end
