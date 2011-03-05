class GroupsWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5, :on_mainlist => true }

  def recent_groups
    Group.where({:state => "active", :private => false, :isolate => false}).order_by(:created_at.desc).paginate(:per_page => self[:settings]['limit'], :page => 1)
  end

  protected
end
