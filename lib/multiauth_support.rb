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
    field :twitter_id,                :type => String

    field :identica_token,             :type => String
    field :identica_secret,            :type => String
    field :identica_login,             :type => String
    field :identica_id,                :type => String

    field :linked_in_id,               :type => String
    field :linked_in_token,            :type => String
    field :linked_in_secret,            :type => String

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

      uid = fields["uid"] || fields["extra"]["user_hash"]["id"]
      auth_key = "#{provider}_#{uid}"

      user = User.where({:auth_keys.in => [auth_key]}).first
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
      if provider == 'twitter' && user.user_info["twitter"] && user.user_info["twitter"]["old"]
        user.user_info["twitter"] = fields["user_info"]
        user.save(:validate => false)
      end
      if provider == 'facebook' && user.user_info["facebook"] && user.user_info["facebook"]["old"]
        user.user_info["facebook"] = fields["user_info"]
        user["facebook_token"] = fields["credentials"]["token"]
        user.save(:validate => false)
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
      user = User.where({:auth_keys.in => [auth_key]}).first

      if user.present? && user.id != self.id
        self.push(:"user_info.#{provider}" => fields["user_info"])

        if merge_user(user)
          user.destroy
          user = self
        end
      end

      if user.respond_to?("handle_#{provider}", true)
        user.send("handle_#{provider}", fields)
        user.save!
      end

      self.push_uniq(:auth_keys => auth_key)
    end

    def merge_user(user)
      #TODO merge friendlist, facebook friend lists and maybe more
      #TODO merging is broken
      [Question, Answer, Badge, UserStat].each do |m|
        m.override({:user_id => user.id}, {:user_id => self.id})
      end
      begin
        if !self.facebook_login? && user.facebook_login?
          self.facebook_friend_list.destroy &&
          FacebookFriendList.override({:user_id => user.id}, {:user_id => self.id})
          #self.update({ :facebook_id => user.facebook_id, :facebook_token => user.facebook_token })
        end
        if user.twitter_login?
          User.override({ :_id => self.id }, { :twitter_id => user.twitter_id, :twitter_token => user.twitter_token,
                        :twitter_secret => user.twitter_secret, :twitter_login => user.twitter_login})
          self.twitter_friend_list.destroy &&
          TwitterFriendList.override({:user_id => user.id}, {:user_id => self.id})
        end
        if user.identica_login?
          User.override({ :_id => self.id }, { :identica_id => user.identica_id,
                          :identica_secret => user.identica_secret,
                          :identica_token => user.identica_token})
          IdenticaFriendsList.override({:user_id => user.id}, {:user_id => self.id}) if self.identica_friends_list.destroy
        end
        if user.linked_in_login?
          User.override({ :_id => self.id }, { :linked_in_id => user.linked_in_id,
                          :identica_secret => user.identica_secret,
                          :identica_token => user.identica_token})
          LinkedInFriendsList.override({:user_id => user.id}, {:user_id => self.id}) if self.linked_in_friends_list.destroy
        end
      rescue Exception => e
        Rails.logger.info e.message
        return nil
      end
      user
    end

    def password_required?
      return false if self[:using_openid] || self[:facebook_id].present? || self[:twitter_id].present? || self[:github_id].present?

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

    def facebook_client(property = 'friends', params = 'fields[]=name&fields[]=picture&fields[]=locale')
      p "https://graph.facebook.com/#{self.facebook_id}/#{property}?access_token=#{self.facebook_token}&#{params}"
      response = open(URI.encode("https://graph.facebook.com/#{self.facebook_id}/#{property}?access_token=#{self.facebook_token}&#{params}")).read
      JSON.parse(response)
    end

    def identica_client
      config = Multiauth.providers["Identica"]
      @consumer = OAuth::Consumer.new(config["id"], config["token"], {:site=>'http://identi.ca'})
      @accesstoken = OAuth::AccessToken.new(@consumer, self.identica_token, self.identica_secret)
    end

    def linked_in_client
      config = Multiauth.providers["LinkedIn"]
      @consumer = OAuth::Consumer.new(config["id"], config["token"], {:site=>'http://api.linkedin.com'})
      @accesstoken = OAuth::AccessToken.new(@consumer, self.linked_in_token, self.linked_in_secret)
    end

    def get_identica_friends
      JSON.parse(identica_client.get('/api/statuses/friends.json').body)
    end

    def get_linked_in_friends
      friends = []
      JSON.parse(linked_in_client.
                 get("/v1/people/~/connections:(id,first-name,last-name,picture-url,location)", 'x-li-format' => 'json').
        body)["values"].map do |friend| friends << { "id" => friend["id"],
          "name" => "#{friend["firstName"]} #{friend["lastName"]}",
          "profile_image_url" => friend["pictureUrl"], "country-code" => friend["location"]["country"]["code"]} end
      friends
    end

    private
    # {"provider"=>"facebook", "uid"=>"4332432432432", "credentials"=>{"token"=>"432432432432432"},
    # "user_info"=>{"nickname"=>"profile.php?id=4332432432432", "first_name"=>"My", "last_name"=>"Name", "name"=>"My Name", "urls"=>{"Facebook"=>"http://www.facebook.com/profile.php?id=4332432432432", "Website"=>nil}},
    # "extra"=>{"user_hash"=>{"id"=>"4332432432432", "name"=>"My Name", "first_name"=>"My", "last_name"=>"Name", "link"=>"http://www.facebook.com/profile.php?id=4332432432432", "birthday"=>"06/15/1980", "gender"=>"male", "email"=>"my email", "timezone"=>-5, "locale"=>"en_US", "updated_time"=>"2010-04-01T07:27:28+0000"}}}
    def handle_facebook(fields)
      uinfo = fields["extra"]["user_hash"].clone
      self.facebook_id = fields["uid"].to_s
      self.facebook_token = fields["credentials"]["token"].to_s
      self.facebook_profile = fields["user_info"]["urls"]["Facebook"].to_s

      if self.email.blank?
        self.email = uinfo["email"]
      end
    end

    # {"provider"=>"twitter", "uid"=>"user id", "credentials"=>{"token"=>"token", "secret"=>"secret"},
    # "extra"=>{"access_token"=>token_object, "user_hash"=>{"description"=>"desc", "screen_name"=>"nick", "geo_enabled"=>false, "profile_sidebar_border_color"=>"87bc44", "status"=>{}}},
    # "user_info"=>{"nickname"=>"nick", "name"=>"My Name", "location"=>"Here", "image"=>"http://a0.twimg.com/profile_images/path.png", "description"=>"desc", "urls"=>{"Website"=>nil}}}
    def handle_twitter(fields)
      self.twitter_token = fields["credentials"]["token"].to_s
      self.twitter_secret = fields["credentials"]["secret"].to_s
      self.twitter_login = fields["user_info"]["nickname"].to_s
      self.twitter_id = fields["uid"].to_s

      self.login.blank? && self.login = fields["user_info"]["nickname"]
    end

    def handle_identica(fields)
      self.identica_token = fields["credentials"]["token"].to_s
      self.identica_secret = fields["credentials"]["secret"].to_s
      self.identica_login = fields["user_info"]["nickname"].to_s
      self.identica_id = fields["extra"]["user_hash"]["id"].to_s

      self.login.blank? && self.login = fields["user_info"]["nickname"].to_s
    end

    def handle_linked_in(fields)
      self.linked_in_token = fields["credentials"]["token"].to_s
      self.linked_in_secret = fields["credentials"]["secret"].to_s
      self.linked_in_id = fields["uid"].to_s
      self.bio.blank? && self.bio = fields["user_info"]["description"].to_s

      self.login.blank? && self.login = fields["user_info"]["first_name"].to_s+fields["user_info"]["last_name"].to_s
    end
  end # InstanceMethods
end
