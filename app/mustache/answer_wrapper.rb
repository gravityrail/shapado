class AnswerWrapper < ModelWrapper

  # returns an array containing the list of comments of a given answer
  # iterate through this array like this:
  # {{#foreach_comment}}
  #   {{author_name}} said {{{markdown}}}
  # {{/foreach_comment}}
  def foreach_comment
    comments = @target.comments
    CollectionWrapper.new(comments, CommentWrapper, view_context)
  end

  # returns the voting widget that allows users to vote up or down an answer
  def vote_box
    view_context.vote_box(@target, view_context.question_path(@target.question), @target.question.closed)
  end

  # returns true if an answer has votes
  def if_has_votes
    self.votes_count > 0
  end

  # returns true if an answer has been accepted as a solution
  def if_accepted
    @target.question.accepted
  end

  # returns true if an answer has comments
  def if_has_comments
    self.comments.count > 0
  end

  # returns the html of the body of an answer
  def markdown
    md = view_context.markdown(@target.body.present? ? @target.body : @target.title)
    view_context.shapado_auto_link(md).html_safe
  end

  # returns the user who created the post, use it like this:
  # {{#author}} {{name}} {{/author}}
  def author
    UserWrapper.new(@target.user, view_context)
  end

  # returns the answer's editor
  def editor
    UserWrapper.new(@target.updated_by, view_context)
  end

  # returns link to the history url
  def history_url
  end

  # returns the date on which the post was created
  def creation_date
    @target.created_at.iso8601
  end

  # formats the creation date of an answer this way: Nov 23 '11 17:31
  def formatted_creation_date
    @target.created_at.strftime("%b %d '%y %H:%M")
  end

  # returns true if an answer has been updated
  def if_has_editor
    @target.updated_by.present?
  end
end
