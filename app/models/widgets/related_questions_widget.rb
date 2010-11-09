class RelatedQuestionsWidget < Widget
  before_validation_on_create :set_name
  before_validation_on_update :set_name
  key :settings, Hash, :default => { :on_show_question => true }

  def question_only?
    true
  end

  protected
  def set_name
    self[:name] ||= "related_questions"
  end
end
