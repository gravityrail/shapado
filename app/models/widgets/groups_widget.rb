class GroupsWidget < Widget
  before_save :set_name

  field :settings, :type => Hash, :default => { :limit => 5 }

  def recent_groups
    Group.where({:state => "active", :private => false, :isolate => false}).order_by(:created_at.desc).paginate(:per_page => self[:settings]['limit'], :page => 1)
  end

  protected
  def set_name
    self[:name] ||= "groups"
  end
end
