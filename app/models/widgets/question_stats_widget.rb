class QuestionStatsWidget < Widget
  before_validation_on_create :set_name
  before_validation_on_update :set_name
  key :settings, Hash, :default => { :on_show_question => true }

  key :settings, Hash, :default => { :limit => 5 }

  def question_only?
    true
  end

  protected
  def set_name
    self[:name] ||= "question_stats"
  end
end
