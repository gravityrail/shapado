class TagListWidget < Widget
  field :settings, :type => Hash, :default => { :on_questions => true }

  def question_only?
    true
  end

end

