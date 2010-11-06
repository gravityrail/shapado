class GroupsWidget < Widget
  before_save :set_name

  field :settings, :type => Hash, :default => { :limit => 5 }

  def recent_groups
    Group.all(:limit => self[:settings][:limit], :order => "created_at desc", :state => "active", :private => false, :isolate => false)
  end

  protected
  def set_name
    self[:name] ||= "groups"
  end
end
