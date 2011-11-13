class QuestionWrapper < ModelWrapper
  def render_question
    view_context.render "questions/question", :question => @target
  end

  def author_name
    @target.user.name
  end

  def author_url
    view_context.user_url(@target.user)
  end

  def url
    view_context.question_url(@target)
  end

  def truncated_description
    view_context.truncate(@target.body, :length => 200)
  end

  def foreach_tag
    tags = current_group.tags.where(:name.in => @target.tags)
    CollectionWrapper.new(tags, TagWrapper, view_context)
  end

  def time_ago
    view_context.time_ago_in_words(@target.created_at)
  end

  def respond_to?(method, priv = false)
    self.orig_respond_to?(method, priv) || @target.respond_to?(method, priv)
  end

  def method_missing(name, *args, &block)
    @target.send(name, *args, &block)
  end
end
