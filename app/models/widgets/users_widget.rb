class UsersWidget < Widget
  before_save :set_name

  field :settings, :type => Hash, :default => { :limit => 5 }

  def recent_users(group)
    group.users(:order => "created_at desc",
                :per_page => self[:settings][:limit],
                :page => 1)
  end

  protected
  def set_name
    self[:name] ||= "users"
  end
end
