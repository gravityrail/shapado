class QuestionWrapper < ModelWrapper
  def render_question
    view_context.render "questions/question", :question => @target
  end

  def last_target_user
    UserWrapper.new(find_last_target[2], view_context)
  end

  def last_target_user_name
    find_last_target[2].display_name
  end

  def last_target_url
    lt_id = find_last_target[0]

    case @target.last_target_type
    when 'Answer'
      view_context.question_url(@target, lt_id)
    when 'Comment'
      view_context.question_url(@target, lt_id)
    else
      view_context.question_url(@target)
    end
  end

  def last_target_date
    find_last_target[1].iso8601
  end

  def last_target_time_ago
    I18n.t("time.ago", :time => view_context.time_ago_in_words(find_last_target[1]))
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

  def editor
    @editor ||= UserWrapper.new(self.updated_by, view_context)
  end

  def author
    @author ||= UserWrapper.new(self.user, view_context)
  end
end
