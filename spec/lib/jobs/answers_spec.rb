require 'spec_helper'

describe Jobs::Answers do
  before(:each) do
    @current_user = User.make
    Thread.current[:current_user] = @current_user
    @question = Question.make(:votes => {})
    @group = @question.group
    @answer = Answer.make(:votes => {}, :question => @question)

    Question.stub!(:find).with(@question.id).and_return(@question)
    @question.answers.stub!(:find).with(@answer.id).and_return(@answer)

    @twitter = mock("twitter client")
    @twitter.stub(:update).with(anything)
    @answer.user.stub!(:twitter_client).and_return @twitter
    @group.stub!(:twitter_client).and_return @twitter

    @question.stub(:group).and_return(@group)

  end

  describe "on_favorite_answer" do
    it "should be successful" do
#       lambda {Jobs::Answers.on_favorite_answer(@answer_id, favoriter_id, link)}.should_not raise_error
    end
  end

  describe "on_create_answer" do
    it "should be successful" do
      link = ""
      Jobs::Answers.on_create_answer(@question.id, @answer.id, link)
      lambda {Jobs::Answers.on_create_answer(@question.id, @answer.id, link)}.should_not raise_error
    end
  end
end
