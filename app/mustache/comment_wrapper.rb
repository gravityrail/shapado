class CommentWrapper < ModelWrapper
  def if_has_votes
    self.votes_count > 0
  end

  def vote_box
    question = @target.find_question
    view_context.vote_box(@target, view_context.question_path(question), question.closed)
  end

  def markdown
    md = view_context.markdown(@target.body.present? ? @target.body : @target.title)
    view_context.shapado_auto_link(md).html_safe
  end

  def author
    UserWrapper.new(@target.user, view_context)
  end

  def creation_date
    self.created_at.iso8601
  end

  def formatted_creation_date
    self.created_at.strftime("%b %d '%y %H:%M")
  end
end