module MultiauthSupport
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, :recoverable, :registerable, :rememberable,
           :lockable, :token_authenticatable, :encryptable, :omniauthable, :encryptor => :restful_authentication_sha1

    key :using_openid, Boolean, :default => false
    key :openid_email

    key :twitter_handle, String
    key :twitter_oauth_token, String
    key :twitter_oauth_secret, String

    key :facebook_id,               String
    key :facebook_token,            String
    key :facebook_profile,          String

    key :twitter_token,             String
    key :twitter_secret,            String
    key :twitter_login,             String


    key :github_id, String
    key :github_login, String
  end

  module ClassMethods
  end # ClassMethods

  module InstanceMethods
    def password_required?
      return false if self[:using_openid] || self[:facebook_id].present? || self[:github_id].present?

      (encrypted_password.blank? || !password.blank?)
    end
  end # InstanceMethods
end
