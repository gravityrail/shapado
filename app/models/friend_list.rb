class FriendList
  include Mongoid::Document

  identity :type => String

  key :follower_ids, Array
  many :followers, :in => :follower_ids, :class_name => "User"

  key :following_ids, Array
  many :following, :in => :following_ids, :class_name => "User"
end
