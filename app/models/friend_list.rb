class FriendList
  include Mongoid::Document

  identity :type => String

  field :follower_ids, :type => Array
  references_many :followers, :stored_as => :array, :inverse_of => :users, :foreign_key => :follower_ids, :class_name => "User" # FIXME mongoid

  field :following_ids, :type => Array
  references_many :following, :stored_as => :array, :inverse_of => :users, :foreign_key => :follower_ids, :class_name => "User"
end
