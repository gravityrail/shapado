class TagListWidget < Widget
  before_validation_on_create :set_name
  before_validation_on_update :set_name
  key :settings, Hash, :default => { :on_questions => true }

  protected
  def set_name
    self[:name] ||= "tag_list"
  end
end

