class OpenidIdentity
  include MongoMapper::Document

  devise :openid_authenticatable

  key :user_id, String
  belongs_to :user

  key :identity_url, String

  key :fields, Hash

  def openid_fields=(fields)
    self.fields = fields
    self.user.try(:openid_fields=, fields)
  end

  def self.openid_required_fields
    User.openid_required_fields
  end

  def self.build_from_identity_url(identity_url)
    new(:identity_url => identity_url)
  end
end
