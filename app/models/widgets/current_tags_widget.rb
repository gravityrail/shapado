class CurrentTagsWidget < Widget
  validate :set_name, :on => :create
  field :settings, :type => Hash, :default => { :on_questions => true }

  protected
  def set_name
    self[:name] ||= "current_tags"
  end
end

