class IdenticaFriendsList
  include Mongoid::Document

  identity :type => String
  field :friends, :type => Array, :default => []
  referenced_in :user
end
