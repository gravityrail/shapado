class UsersWidget < Widget
  field :settings, :type => Hash, :default => { 'limit' => 5, :on_mainlist => true  }


  def recent_users(group)
    group.memberships.order_by(%W[created_at desc]).limit(self[:settings]['limit']).
      paginate(:per_page => self[:settings]['limit'], :page => 1)
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
