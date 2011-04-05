class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  identity :type => String
  field :token, :type => String
  index :token
  field :email, :type => String
  index :email
  field :accepted, :type => Boolean, :default => false

  referenced_in :group
  referenced_in :user

  before_create :generate_token

  validates_uniqueness_of :user_id, :scope => [:group_id, :email]

  protected
  def generate_token
    self.token = UUIDTools::UUID.random_create.hexdigest
  end
end
