class BountyController < ApplicationController
  before_filter :login_required
  before_filter :find_question

  def start
    if @question.bounty && @question.bounty.active
      flash[:notice] = "this question has an active bounty" # TODO: i18n
      redirect_to question_path(@question)
      return
    end

    if Time.now - @question.created_at < 2.days
      flash[:notice] = "you should wait 2 days before offering a bounty on this question" # TODO: i18n
      redirect_to question_path(@question)
      return
    end

    config = current_user.config_for(current_group)

    if config.reputation < 75
      flash[:notice] = "you don't have enough reputation to create a bounty on this question" # TODO: i18n
      redirect_to question_path(@question)
      return
    end

    @question.build_bounty(params[:bounty])
    @question.bounty.created_by = current_user
    @question.bounty.started_at = Time.now
    @question.bounty.ends_at = Time.now + 1.week

    if !@question.bounty.valid?
      flash[:notice] = @question.bounty.errors.full_messages.join(" ")
      redirect_to question_path(@question)
      return
    end

    @question.override(:bounty => @question.bounty.raw_attributes) # FIXME: buggy mongoid assocs

    current_user.update_reputation(:start_bounty, current_group, -@question.bounty.reputation)

    redirect_to question_path(@question)
  end

  def close
    if @question.bounty.ends_at < Time.now
      flash[:notice] = "the bounty has expired"
      @question.bounty.reward(current_group)
      redirect_to question_path(@question)
      return
    end

    if (Time.now - @question.bounty.started_at) < 1.day
      flash[:error] = "you must wait #{distance_of_time_in_words(Time.now, @question.bounty.started_at)} before awarding this bounty." # TODO: i18n
      redirect_to question_path(@question)
      return
    end

    @answer = @question.answers.where(:_id => params[:answer_id]).first
    @question.bounty.reward(current_group, @answer)

    redirect_to question_path(@question)
  end

  protected
  def find_question
    @question = Question.minimal.by_slug(params[:id])
  end
end
