class QuestionWrapper < ModelWrapper
  def render_question
    view_context.render "questions/question", :question => @target
  end

  def author_name
    @target.user.display_name
  end

  def author_url
    view_context.user_url(@target.user)
  end

  def url
    view_context.question_url(@target)
  end

  def views_count
    view_context.format_number(@target.views_count)
  end

  def truncated_description
    view_context.truncate(@target.body, :length => 200)
  end

  def foreach_tag
    tags = current_group.tags.where(:name.in => @target.tags)
    CollectionWrapper.new(tags, TagWrapper, view_context)
  end

  def foreach_related_question
    questions = Question.related_questions(@target)
    CollectionWrapper.new(questions, QuestionWrapper, view_context)
  end

  def foreach_comment
    comments = @target.comments
    CollectionWrapper.new(comments, CommentWrapper, view_context)
  end

  def foreach_answer
    answers = @target.answers
    CollectionWrapper.new(answers, AnswerWrapper, view_context)
  end

  def time_ago
    view_context.time_ago_in_words(@target.created_at)
  end

  def markdown
    md = view_context.markdown(@target.body.present? ? @target.body : @target.title)
    view_context.shapado_auto_link(md).html_safe
  end

  def edit_question_url
    view_context.edit_question_url(@target)
  end

  def history_url
  end

  def feed_url
    view_context.question_url(@question, :format => "atom")
  end

  def if_has_editor
    @target.updated_by.present?
  end

  def if_has_comments
    self.comments.count > 0
  end

  def editor_url
    view_context.user_url(@target.updated_by)
  end

  def editor_avatar
    view_context.avatar_img(@target.updated_by, :size => 'small')
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

  def owner_url
    view_context.user_url(@target.user)
  end

  def owner_avatar
    view_context.avatar_img(@target.user, :size => 'small')
  end

  def owner_name
    @target.user.display_name
  end

  def owner_reputation
    @target.user.config_for(current_group).reputation.to_i
  end

  def owner_gold_badges_count
    @target.user.config_for(current_group).gold_badges_count
  end

  def owner_silver_badges_count
    @target.user.config_for(current_group).silver_badges_count
  end

  def owner_bronze_badges_count
    @target.user.config_for(current_group).bronze_badges_count
  end

  def respond_to?(method, priv = false)
    self.orig_respond_to?(method, priv) || @target.respond_to?(method, priv)
  end

  def method_missing(name, *args, &block)
    @target.send(name, *args, &block)
  end
end
