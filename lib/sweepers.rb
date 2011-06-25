module Sweepers
  def sweep_question_views
    expire_fragment_for("widgets")
    expire_fragment_for("question")
    expire_fragment_for("answers")
  end

  def sweep_answer_views
  end

  def sweep_widgets
    expire_fragment_for("widgets")
  end

  def sweep_user_views
    expire_fragment_for("widgets")
  end

  def sweep_question(question)
    expire_fragment_for("question", question.id)
    expire_fragment_for("questions")
  end

  def sweep_new_users(group)
    expire_fragment_for("widgets")
  end

  private
  def expire_fragment_for(name, *args)
    extra = ""
    if !args.empty?
      extra << ".+"
      extra << args.map{|a| Regexp.escape(a.to_s) }.join(".+")
    end
    expire_fragment(/#{Regexp.escape(name)}.+#{current_group.id}#{extra}/)
  end
end
