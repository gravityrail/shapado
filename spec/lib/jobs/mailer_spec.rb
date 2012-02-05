require 'spec_helper'

describe Jobs::Mailer do
  before(:each) do
    @current_user = User.make
    Thread.current[:current_user] = @current_user
    @question = Question.make(:votes => {})
    @group = @question.group
    @answer = Answer.make(:votes => {}, :question => @question)
  end

  describe "on_ask_question" do
  end

  describe "on_new_comment" do
    comment = Comment.make(:commentable => @question, :user => @current_user)
    lambda {Jobs::Mailer.on_new_comment(@question.id, 'Question', comment.id)}.should_not raise_error
  end

  describe "on_favorite_answer" do
  end

  describe "on_follow" do
  end

  describe "on_new_invitation" do
  end
end
