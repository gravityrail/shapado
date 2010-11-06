class BadgesWidget < Widget
  before_save :set_name

  field :settings, :type => Hash, :default => { :limit => 5 }

  def recent_badges(group)
    group.badges.all(:limit => self[:settings][:limit], :order => "created_at desc")
  end


  protected
  def set_name
    self[:name] ||= "badges"
  end
end
