class TopGroupsWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5, :on_welcome => true  }

  def top_groups
    Group.where({:state => "active", :private => false, :isolate => false}).order_by(:activity_rate.desc).paginate(:per_page => self[:settings]['limit'], :page => 1)
  end

  protected
end
