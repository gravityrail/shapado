class QuestionStatsWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5, :on_show_question => true }

  def question_only?
    true
  end

  protected
end
