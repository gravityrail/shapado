class UsersWidget < Widget
  before_save :set_name

  field :settings, :type => Hash, :default => { :limit => 5 }

  def recent_users(group)
    group.users({:per_page => self[:settings][:limit],
                 :page => 1}).order_by(:created_at.desc)
  end

  protected
  def set_name
    self[:name] ||= "users"
  end
end
