class BadgesWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5, :on_mainlist => true  }

  def recent_badges(group)
    group.badges.order_by(:created_at.desc).paginate(:per_page => self[:settings]['limit'], :page => 1)
  end

  protected
  def check_settings
    valid = settings["limit"].to_i > 1
    unless valid
      self.errors.add(:limit, I18n.t(:"errors.messages.greater_than", :count => settings["limit"].to_i))
    end
    valid
  end
end
