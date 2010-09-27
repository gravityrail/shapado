module MultiauthSupport
  def self.included(base)
    base.class_eval do
      key :using_openid, Boolean, :default => false

      has_many :openid_identities
      key :openid_email

      key :twitter_handle, String
      key :twitter_oauth_token, String
      key :twitter_oauth_secret, String

      key :github_id, String
      key :github_login, String

      extend ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def find_by_identity_url(identity_url)
      OpenidIdentity.first(:identity_url => identity_url).try(:user)
    end

    def build_from_identity_url(identity_url)
      user = User.new(:using_openid => true)
      user.openid_identities << OpenidIdentity.new(:identity_url => identity_url)
      if user.login.blank?
        login = user.email.to_s.split("@", 2)[0]
        login = "#{user.id[0,8]}_openid" if login.blank?

        user.login = login
      end
      user
    end

    def find_for_github_oauth(access_token, signed_in_resource=nil)
      data = ActiveSupport::JSON.decode(access_token.get('/api/v2/json/user/show'))
      user_data = data["user"]

      if user_data["email"]
        user = User.find_by_email(user_data["email"])
      elsif user_data["id"]
        user = User.first(:github_id => user_data["id"].to_s)
      end

      if user.present?
        user
      else
        User.create!(:name => user_data["name"], :email => user_data["email"],
                     :github_id => user_data["id"], :login => "#{user_data["login"]}_github",
                     :github_login => user_data["login"])
      end
    end

    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = ActiveSupport::JSON.decode(access_token.get('/me'))

      if user = User.find_by_email(data["email"])
        user
      else
        User.create!(:name => data["name"], :email => data["email"],
                     :facebook_id => data["id"], :facebook_profile => data["link"])
      end
    end

    def openid_required_fields
      ["nickname", "fullname", "email", "http://axschema.org/pref/language", "http://axschema.org/contact/email"]
    end

    def openid_optional_fields
      %w[
        http://axschema.org/namePerson/friendly
        http://axschema.org/namePerson
        http://axschema.org/birthDate
        gender
        http://axschema.org/person/gender
        http://axschema.org/contact/postalCode/home
        country
        http://axschema.org/contact/country/home
        language
        http://axschema.org/pref/timezone
      ]
    end
  end # ClassMethods

  module InstanceMethods
    def openid_fields=(fields)
      logger.info "OPENID FIELDS: #{fields.inspect}"
      fields.each do |key, value|
        if value.is_a? Array
          value = value.first
        end

        case key.to_s
        when /nickname/
          self.login = value if self.login.blank?
        when "fullname", "http://axschema.org/namePerson"
          self.full_name = value
        when "email", "http://axschema.org/contact/email"
          if self.email.blank?
            self.email = value
          else
            self.openid_email = value
          end
        when "gender", "http://axschema.org/person/gender"
          self.gender = value
        when "language", "http://axschema.org/pref/language"
          self.language = value
        else
          logger.error "Unknown OpenID field: #{key}"
        end
      end
    end

    def password_required?
      return false if self[:using_openid] || self[:facebook_id].present? || self[:github_id].present?

      (encrypted_password.blank? || !password.blank?)
    end
  end # InstanceMethods
end
