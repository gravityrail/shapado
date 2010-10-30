module MultiauthSupport
  extend ActiveSupport::Concern

  included do
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

    key :auth_keys, Array
    key :user_info, Hash
  end

  module ClassMethods
    def authenticate(fields)
      provider = fields["provider"]

      if fields["uid"] =~ %r{google\.com/accounts/o8/} && fields["user_info"]["email"]
        fields["uid"] = "http://google_id_#{fields["user_info"]["email"]}" # normalize for subdomains
      end

      auth_key = "#{provider}_#{fields["uid"]}"
      user = User.first(:auth_keys => auth_key)
      if user.nil?
        user = User.new(:auth_keys => [auth_key])

        puts ">>>>>>> #{provider} #{fields["user_info"].inspect}"

        user.user_info[provider] = fields["user_info"]

        if user.email.blank?
          user.email = user.user_info[provider]["email"]
        end

        if user.login.blank?
          if user.email.blank?
            user.login = user.user_info[provider]["nickname"] || user.user_info[provider]["login"] || user.user_info[provider]["name"] || "#{provider}_#{rand(100)}#{rand(100)}#{rand(100)}"
          else
            user.login = user.email.split("@").first.downcase.gsub(".","")
          end
        end

        if !user.valid? && !user.errors.on(:login).empty?
          user.login = user.login + "_#{rand(100)}#{rand(100)}#{rand(100)}"
        end

        return false if !user.save
      end

      user
    end
  end # ClassMethods

  module InstanceMethods
    def connect(fields)
      if fields["uid"] =~ %r{google\.com/accounts/o8/} && fields["user_info"]["email"]
        fields["uid"] = "google_openid_#{fields["user_info"]["email"]}"
      end

      auth_key = "#{fields["provider"]}_#{fields["uid"]}"
      user = User.first(:auth_keys => auth_key, :select => [:id])
      if user.present? && user.id != self.id
        self.push(:"user_info.#{fields["provider"]}" => fields["user_info"])

        user.destroy if merge_account(user)
      end

      self.push_uniq(:auth_keys => auth_key)
    end

    def merge_account(other_user)
      false
    end

    def password_required?
      return false if self[:using_openid] || self[:facebook_id].present? || self[:github_id].present?

      (encrypted_password.blank? || !password.blank?)
    end
  end # InstanceMethods
end
