class BadgesWidget < Widget
  before_validation_on_create :set_name
  before_validation_on_update :set_name

  key :settings, Hash, :default => { :limit => 5, :on_welcome => true }

  def recent_badges(group)
    group.badges.all(:limit => self[:settings][:limit], :order => "created_at desc")
  end


  protected
  def set_name
    self[:name] ||= "badges"
  end
end
