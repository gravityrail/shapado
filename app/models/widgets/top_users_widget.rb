class TopUsersWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5, :on_mainlist => true  }

  def top_users(group)
    group.memberships.order_by(%W[reputation desc]).limit(self[:settings]['limit']).
                      paginate(:per_page => self[:settings]['limit'], :page => 1)
  end

  protected
end
