class TopUsersWidget < Widget
  before_validation_on_create :set_name
  before_validation_on_update :set_name

  key :settings, Hash, :default => { :limit => 5 }

  def top_users(group)
    group.users(:order => "membership_list.#{group.id}.reputation desc",
                :per_page => self[:settings][:limit],
                :page => 1)
  end

  protected
  def set_name
    self[:name] ||= "top_users"
  end
end
