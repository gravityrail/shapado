class BadgesWidget < Widget
  before_save :set_name

  field :settings, :type => Hash, :default => { :limit => 5 }

  def recent_badges(group)
    group.badges.order_by(:created_at.desc).paginate(:per_page => self[:settings]['limit'], :page => 1)
  end


  protected
  def set_name
    self[:name] ||= "badges"
  end
end
