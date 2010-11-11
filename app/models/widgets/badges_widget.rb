class BadgesWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5, :on_welcome => true  }

  def recent_badges(group)
    group.badges.order_by(:created_at.desc).paginate(:per_page => self[:settings]['limit'], :page => 1)
  end


  protected
end
