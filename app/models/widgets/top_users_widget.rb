class TopUsersWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5, :on_mainlist => true  }

  def top_users(group)
    # order_by(%W[membership_list.#{group.id}.reputation desc]). FIXME: needs an index
    group.users.paginate(
                :per_page => self[:settings]['limit'],
                :page => 1)
  end

  protected
end
