class BadgesWidget < Widget
  before_save :set_name

<<<<<<< HEAD
  field :settings, :type => Hash, :default => { :limit => 5 }
=======
  key :settings, Hash, :default => { :limit => 5, :on_welcome => true }
>>>>>>> next

  def recent_badges(group)
    group.badges.order_by(:created_at.desc).paginate(:per_page => self[:settings]['limit'], :page => 1)
  end


  protected
  def set_name
    self[:name] ||= "badges"
  end
end
