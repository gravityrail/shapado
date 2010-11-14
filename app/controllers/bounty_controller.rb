class BountyController < ApplicationController
  before_filter :login_required
  before_filter :find_question

  def start
    if @question.bounty && @question.bounty.active
      flash[:notice] = "this question has an active bounty"
      redirect_to question_path(@question)
      return
    end

    if Time.now - @question.created_at < 2.days
      flash[:notice] = "you should wait 2 days before offering a bounty on this question"
      redirect_to question_path(@question)
      return
    end

    config = current_user.config_for(current_group)

    if config.reputation < 75
      flash[:notice] = "you don't have enough reputation to create a bounty on this question"
      redirect_to question_path(@question)
      return
    end

    bounty = Bounty.new(params[:bounty])

    if !bounty.valid?
      flash[:notice] = bounty.errors.full_messages.join(" ")
      redirect_to question_path(@question)
      return
    end

    bounty.started_at = Time.now
    bounty.ends_at = Time.now + 1.week

    @question.bounty = bounty
    @question.save

    redirect_to question_path(@question)
  end

  def close
    redirect_to question_path(@question)
  end

  protected
  def find_question
    @question = Question.minimal.by_slug(params[:id])
  end
end
