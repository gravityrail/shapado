class VotesController < ApplicationController
  before_filter :find_voteable
  before_filter :check_permissions, :except => [:index]


  def index
    redirect_to(root_path)
  end

  # TODO: refactor
  def create
    vote = Vote.new(:user => current_user)
    vote_type = ""
    if params[:vote_up] || params['vote_up.x'] || params['vote_up.y']
      vote_type = "vote_up"
      vote.value = 1
    elsif params[:vote_down] || params['vote_down.x'] || params['vote_down.y']
      vote_type = "vote_down"
      vote.value = -1
    end

    vote, vote_state = push_vote(vote)

    if vote_state == :created && !vote.new?
      if @voteable.class == Question
        sweep_question(vote.voteable)

        Jobs::Votes.async.on_vote_question(@voteable.id, vote.id).commit!
      elsif @voteable.class == Answer
        Jobs::Votes.async.on_vote_answer(@voteable.id, vote.id).commit!
      end
    end

    respond_to do |format|
      format.html{redirect_to params[:source]}

      format.js do
        if vote_state != :error
          average = @voteable.reload.votes_average
          render(:json => {:success => true,
                           :message => flash[:notice],
                           :vote_type => vote_type,
                           :vote_state => vote_state,
                           :average => average}.to_json)
        else
          render(:json => {:success => false, :message => flash[:error] }.to_json)
        end
      end

      format.json do
        if vote_state != :error
          average = @voteable.reload.votes_average
          render(:json => {:success => true,
                           :message => flash[:notice],
                           :vote_type => vote_type,
                           :vote_state => vote_state,
                           :average => average}.to_json)
        else
          render(:json => {:success => false, :message => flash[:error] }.to_json)
        end
      end
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    voteable = @vote.voteable
    value = @vote.value
    if  @vote && current_user == @vote.user
      @vote.destroy
      if voteable.kind_of?(Question)
        sweep_question(voteable)
      end
      voteable.remove_vote!(value, current_user)
    end
    respond_to do |format|
      format.html { redirect_to params[:source] }
      format.json  { head :ok }
    end
  end

  protected
  def find_voteable
    if params[:answer_id]
      @voteable = current_group.answers.find(params[:answer_id])
    elsif params[:question_id]
      @voteable = current_group.questions.find_by_slug_or_id(params[:question_id])
    end

    if params[:comment_id]
      @voteable = @voteable.comments.find(params[:comment_id])
    end
  end

  def check_permissions
    unless logged_in?
      flash[:error] = t(:unauthenticated, :scope => "votes.create")
      respond_to do |format|
        format.html do
          flash[:error] += ", [#{t("global.please_login")}](#{new_user_session_path})"
          redirect_to params[:source]
        end
        format.json do
          flash[:error] = t("global.please_login")
          render(:json => {:status => :unauthenticate, :success => false, :message => flash[:error] }.to_json)
        end
        format.js do
          flash[:error] = t("global.please_login")
          render(:json => {:status => :unauthenticate, :success => false, :message => flash[:error] }.to_json)
        end
      end
    end
  end

  def push_vote(vote)
    user_vote = current_user.vote_on(@voteable)
    vote.voteable = @voteable
    state = :error
    if user_vote.nil?

      if vote.valid?
        vote.save
        @voteable.add_vote!(vote.value, current_user)
        flash[:notice] = t("votes.create.flash_notice")
        state = :created
      else
        flash[:error] = vote.errors.full_messages.join(", ")
      end
    elsif(user_vote.valid?)
      if(user_vote.value != vote.value)
        @voteable.remove_vote!(user_vote.value, current_user)
        @voteable.add_vote!(vote.value, current_user)

        user_vote.value = vote.value
        user_vote.save
        flash[:notice] = t("votes.create.flash_notice")
        state = :updated
      else
        value = vote.value
        user_vote.destroy
        @voteable.remove_vote!(value, current_user)
        flash[:notice] = t("votes.destroy.flash_notice")
        state = :deleted
      end
      vote = user_vote
    else
      flash[:error] = user_vote.errors.full_messages.join(", ")
      state = :error
    end

    if @voteable.is_a?(Answer)
      question = @voteable.question
      sweep_question(question)

      if vote.value == 1
        question.override(:answered_with_id => @voteable.id) if !question.answered
      elsif question.answered_with_id == @voteable.id && @voteable.votes_average <= 1
        question.override(:answered_with_id => nil)
      end
    end

    [vote, state]
  end
end
