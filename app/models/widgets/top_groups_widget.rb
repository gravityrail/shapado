class TopGroupsWidget < Widget
  before_save :set_name

  field :settings, :type => Hash, :default => { :limit => 5 }

  def top_groups
    Group.order_by(:activity_rate.desc).paginate(:per_page => self[:settings][:limit], :conditions => {:state => "active", :private => false, :isolate => false})
  end

  protected
  def set_name
    self[:name] ||= "top_groups"
  end
end
