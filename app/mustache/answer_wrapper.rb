class AnswerWrapper < ModelWrapper
  def foreach_comment
    comments = @target.comments
    CollectionWrapper.new(comments, CommentWrapper, view_context)
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

  def author_url
    view_context.user_url(@target.user)
  end

  def history_url
  end

  def author_reputation
    @target.user.config_for(current_group).reputation.to_i
  end

  def author_name
    @target.user.display_name
  end

  def author_avatar
    view_context.avatar_img(@target.user, :size => 'small').html_safe
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

  def editor_url
    view_context.user_url(@target.updated_by)
  end

  def editor_avatar
    view_context.avatar_img(@target.updated_by, :size => 'small').html_safe
  end

  def editor_name
    @target.updated_by.display_name
  end

  def editor_reputation
    @target.updated_by.config_for(current_group).reputation.to_i
  end

  def editor_gold_badges_count
    @target.updated_by.config_for(current_group).gold_badges_count
  end

  def editor_silver_badges_count
    @target.updated_by.config_for(current_group).silver_badges_count
  end

  def editor_bronze_badges_count
    @target.updated_by.config_for(current_group).bronze_badges_count
  end
end