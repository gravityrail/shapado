class UsersWidget < Widget
  validate :set_name, :on => :create
  field :settings, :type => Hash, :default => { :limit => 5, :on_welcome => true  }


  def recent_users(group)
    group.users({:per_page => self[:settings]['limit'],
                 :page => 1}).order_by(:created_at.desc)
  end

  protected
  def set_name
    self[:name] ||= "users"
  end
end
