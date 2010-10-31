module Jobs
  class Users
    extend Jobs::Base

    def self.post_to_twitter(user_id, text)
      user = User.find(user_id)

      client = user.twitter_client

      client.update(text)
    end

    def self.on_update_user(user_id, group_id)
      user = User.find(user_id)
      group = Group.find(group_id)

      if !user.birthday.blank? && !user.website.blank? && !user.bio.blank? && !user.name.blank?
        create_badge(user, group, :token => "autobiographer", :unique => true)
      end
    end
  end
end
