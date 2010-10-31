module Jobs
  module Base
    include Magent::Async

    def create_badge(user, group, opts, check_opts = {})
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

      if !badge.new? && !user.email.blank? && user.notification_opts.activities
        Notifier.deliver_earned_badge(user, group, badge)
      end
    end
  end
end

