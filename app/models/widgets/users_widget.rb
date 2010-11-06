class UsersWidget < Widget
  before_validation_on_create :set_name
  before_validation_on_update :set_name

  key :settings, Hash, :default => { :limit => 5, :on_welcome => true }

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
