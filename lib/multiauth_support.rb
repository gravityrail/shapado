module MultiauthSupport
  extend ActiveSupport::Concern

  included do
    field :using_openid, :type => Boolean, :default => false
    field :openid_email

    field :twitter_handle, :type => String
    field :twitter_oauth_token, :type => String
    field :twitter_oauth_secret, :type => String

    field :facebook_id,               :type => String
    field :facebook_token,            :type => String
    field :facebook_profile,          :type => String

    field :twitter_token,             :type => String
    field :twitter_secret,            :type => String
    field :twitter_login,             :type => String


    field :github_id, :type => String
    field :github_login, :type => String

    field :auth_keys, :type => Array, :default => []
    field :user_info, :type => Hash, :default => {}
  end

  module ClassMethods
    def authenticate(fields)
      puts "FIELDS #{fields.inspect}"

      provider = fields["provider"]

      if fields["uid"] =~ %r{google\.com/accounts/o8/} && fields["user_info"]["email"]
        fields["uid"] = "http://google_id_#{fields["user_info"]["email"]}" # normalize for subdomains
      end

      auth_key = "#{provider}_#{fields["uid"]}"

      user = User.where({:auth_keys => auth_key}).first
      if user.nil?
        user = User.new(:auth_keys => [auth_key])

        puts ">>>>>>> #{provider} #{fields["user_info"].inspect}"

        user.user_info[provider] = fields["user_info"]

        if user.email.blank?
          user.email = user.user_info[provider]["email"]
        end

        user.send("handle_#{provider}", fields) if user.respond_to?("handle_#{provider}", true)

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
      provider = fields["provider"]
      if fields["uid"] =~ %r{google\.com/accounts/o8/} && fields["user_info"]["email"]
        fields["uid"] = "http://google_id_#{fields["user_info"]["email"]}" # normalize for subdomains
      end

      auth_key = "#{provider}_#{fields["uid"]}"
      user = User.only(:id).where({:auth_keys => auth_key}).first
      if user.present? && user.id != self.id
        self.push(:"user_info.#{provider}" => fields["user_info"])

        user.destroy if merge_user(user)
      end

      user.send("handle_#{provider}", fields) if user.respond_to?("handle_#{provider}", true)

      self.push_uniq(:auth_keys => auth_key)
    end

    def merge_user(user)
      [Question, Answer, Badge, UserStat].each do |m|
        m.override({:user_id => user.id}, {:user_id => self.id})
      end
      user
    end

    def password_required?
      return false if self[:using_openid] || self[:facebook_id].present? || self[:github_id].present?

      (encrypted_password.blank? || !password.blank?)
    end

    def twitter_client
      if self.twitter_secret.present? && self.twitter_token.present? && (config = Multiauth.providers["Twitter"])
        TwitterOAuth::Client.new(
          :consumer_key => config["id"],
          :consumer_secret => config["token"],
          :token => self.twitter_token,
          :secret => self.twitter_secret
        )
      end
    end

    private
    # {"provider"=>"facebook", "uid"=>"4332432432432", "credentials"=>{"token"=>"432432432432432"},
    # "user_info"=>{"nickname"=>"profile.php?id=4332432432432", "first_name"=>"My", "last_name"=>"Name", "name"=>"My Name", "urls"=>{"Facebook"=>"http://www.facebook.com/profile.php?id=4332432432432", "Website"=>nil}},
    # "extra"=>{"user_hash"=>{"id"=>"4332432432432", "name"=>"My Name", "first_name"=>"My", "last_name"=>"Name", "link"=>"http://www.facebook.com/profile.php?id=4332432432432", "birthday"=>"06/15/1980", "gender"=>"male", "email"=>"my email", "timezone"=>-5, "locale"=>"en_US", "updated_time"=>"2010-04-01T07:27:28+0000"}}}
    def handle_facebook(fields)
      uinfo = fields["extra"]["user_hash"]
      self.facebook_id = fields["uid"]
      self.facebook_token = fields["credentials"]["token"]
      self.facebook_profile = fields["user_info"]["urls"]["Facebook"]

      if self.email.blank?
        self.email = uifo["email"]
      end
    end

    # {"provider"=>"twitter", "uid"=>"user id", "credentials"=>{"token"=>"token", "secret"=>"secret"},
    # "extra"=>{"access_token"=>token_object, "user_hash"=>{"description"=>"desc", "screen_name"=>"nick", "geo_enabled"=>false, "profile_sidebar_border_color"=>"87bc44", "status"=>{}}},
    # "user_info"=>{"nickname"=>"nick", "name"=>"My Name", "location"=>"Here", "image"=>"http://a0.twimg.com/profile_images/path.png", "description"=>"desc", "urls"=>{"Website"=>nil}}}
    def handle_twitter(fields)
      self.twitter_token = fields["credentials"]["token"]
      self.twitter_secret = fields["credentials"]["secret"]
      self.twitter_login = fields["user_info"]["nickname"]

      self.login.blank? && self.login = fields["user_info"]["nickname"]
    end
  end # InstanceMethods
end
