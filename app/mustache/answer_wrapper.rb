class AnswerWrapper < ModelWrapper
  def foreach_comment
    comments = @target.comments
    CollectionWrapper.new(comments, CommentWrapper, view_context)
  end

  def vote_box
    view_context.vote_box(@target, view_context.question_path(@target.question), @target.question.closed)
  end

  def if_has_votes
    self.votes_count > 0
  end

  def if_accepted
    @target.question.accepted
  end

  def if_has_comments
    self.comments.count > 0
  end

  def markdown
    md = view_context.markdown(@target.body.present? ? @target.body : @target.title)
    view_context.shapado_auto_link(md).html_safe
  end

  def author
    UserWrapper.new(@target.user, view_context)
  end

  def editor
    UserWrapper.new(@target.updated_by, view_context)
  end

  def history_url
  end

  def creation_date
    @target.created_at.iso8601
  end

  def formatted_creation_date
    @target.created_at.strftime("%b %d '%y %H:%M")
  end

  def if_has_editor
    @target.updated_by.present?
  end
end