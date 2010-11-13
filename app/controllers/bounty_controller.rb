class BountyController < ApplicationController
  before_filter :find_question

  def start
  end

  def close

  end

  protected
  def find_question
    @question = Question.minimal.where(:_id => params[:id]).first
  end
end
