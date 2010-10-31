module VotesHelper
  def vote_box(voteable, source, closed = false)
    class_name = voteable.class.name
    url = ""
    if voteable.is_a?(Question)
      url = question_votes_path(voteable)
    elsif voteable.is_a?(Answer)
      url = question_answer_votes_path(voteable.question, voteable)
    elsif voteable.is_a?(Comment)
      commentable = voteable.commentable
      if commentable.is_a?(Question)
        url = question_comment_votes_path(commentable, voteable)
      elsif commentable.is_a?(Answer)
        url = question_answer_comment_votes_path(commentable.question,commentable,voteable)
      end
    end
    if !closed && (logged_in? && voteable.user != current_user) || !logged_in?
      vote = current_user.vote_on(voteable) if logged_in?
      %@
      <form action='#{url}' method='post' class='vote_form' >
        <div>
          #{token_tag}
        </div>
        <div class='vote_box'>
          #{hidden_field_tag "source", source, :id => "source_#{class_name}_#{voteable.id}"}
          <button type="submit" name="vote_up" value="1" class="arrow vote_up">
            #{if vote && vote.value > 0
                image_tag("vote_up.png", :width => 30, :height => 16, :title => I18n.t("votes.control.have_voted_up"))
              else
                image_tag("to_vote_up.png", :width => 30, :height => 16, :title => I18n.t("votes.control.to_vote_up"))
              end
             }
          </button>
          <div class="votes_average">
            #{calculate_votes_average(voteable)}
          </div>
          <button type="submit" name="vote_down" value="-1" class="arrow vote_down">
            #{if vote && vote.value < 0
                image_tag("vote_down.png", :width => 30, :height => 16, :title => I18n.t("votes.control.have_voted_down"))
              else
                image_tag("to_vote_down.png", :width => 30, :height => 16, :title => I18n.t("votes.control.to_vote_down"))
              end}
          </button>
        </div>
      </form>
      @
    else
      %@
        <div class='vote_box'>
          <div class="arrow vote_up">
            #{image_tag("to_vote_up.png", :width => 30, :height => 16)}
          </div>
          <div class="votes_average">
            #{calculate_votes_average(voteable)}
          </div>
          <div class="arrow vote_down">
            #{image_tag("to_vote_down.png", :width => 30, :height => 16)}
          </div>
        </div>
      @
    end
  end

  def calculate_votes_average(voteable)
    if voteable.respond_to?(:votes_average)
      voteable.votes_average
    else
      t = 0
      voteable.votes.each {|e| t += e.value }
      t
    end
  end
end
