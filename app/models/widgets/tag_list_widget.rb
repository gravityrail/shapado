class TagListWidget < Widget
  validate :set_name, :on => :create
  field :settings, :type => Hash, :default => { :on_questions => true }

  protected
  def set_name
    self[:name] ||= "tag_list"
  end
end

