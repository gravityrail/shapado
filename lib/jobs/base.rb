module Jobs
  module Base
    include Magent::Async

    def create_badge(user, group, opts, check_opts = {})
      return if user.admin?

      unique = opts.delete(:unique) || check_opts.delete(:unique)

      ok = true
      if unique
        ok = user.find_badge_on(group, opts[:token], check_opts).nil?
      end

      return unless ok

      badge = user.badges.create(opts.merge({:group_id => group.id}))
      if !badge.valid?
        puts "Cannot create the #{badge.token} badge: #{badge.errors.full_messages}"
      else
        user.increment(:"membership_list.#{group.id}.#{badge.type}_badges_count" => 1)
        if badge.token == "editor"
          user.set(:"membership_list.#{group.id}.is_editor" => true)
        end
      end

      if !badge.new?
        if !user.email.blank? && user.notification_opts.activities
          Notifier.deliver_earned_badge(user, group, badge)
        end
        if user.notification_opts.badges_to_twitter
          token = badge.name(user.language)
          group_name = group.name
          link = group.domain
          user.twitter_client.update(I18n.t('jobs.base.create_badge.send_twitter', :link => link, :token => token, :group_name => group_name))
        end
      end
    end

    def shorten_url(url)
      open("http://bit.ly/api?url=#{CGI.encode(url)}").read rescue url
    end
  end
end

