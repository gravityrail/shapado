class UsersWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5, :on_welcome => true  }


  def recent_users(group)
    group.users({:per_page => self[:settings]['limit'],
                 :page => 1}).order_by(:created_at.desc)
  end

  protected
end
