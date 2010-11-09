class QuestionStatsWidget < Widget
  validate :set_name, :on => :create
  field :settings, :type => Hash, :default => { :limit => 5, :on_show_question => true }

  def question_only?
    true
  end

  protected
  def set_name
    self[:name] ||= "question_stats"
  end
end
