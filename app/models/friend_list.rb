class FriendList
  include Mongoid::Document

  identity :type => String

  field :follower_ids, :type => Array
  references_and_referenced_in_many :followers, :inverse_of => :users, :foreign_key => :follower_ids, :class_name => "User" # FIXME mongoid

  field :following_ids, :type => Array
  references_and_referenced_in_many :following, :inverse_of => :users, :foreign_key => :follower_ids, :class_name => "User"
end
