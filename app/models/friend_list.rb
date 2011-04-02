class FriendList
  include Mongoid::Document

  identity :type => String

  references_one :user

  field :follower_ids, :type => Array, :default => []
  references_and_referenced_in_many :followers, :foreign_key => :follower_ids, :class_name => "User" # FIXME mongoid

  field :following_ids, :type => Array, :default => []
  references_and_referenced_in_many :following, :foreign_key => :follower_ids, :class_name => "User"
end
