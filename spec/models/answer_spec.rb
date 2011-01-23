require 'spec_helper'

describe Answer do
  before(:each) do
    @answer = Answer.make(:votes => {})
  end

  describe "module/plugin inclusions (optional)" do
  end

  describe "validations" do
    it "the answer of a user in a question should be unique" do
      answer = Answer.make_unsaved(:question_id => @answer.question_id,
                                   :created_at => @answer.created_at+1.day,
                                   :user_id => @answer.user_id,
                                   :group_id => @answer.group_id,
                                   :votes => {})
      answer.valid?.should be_false
      answer.errors[:limitation].should_not be_nil
    end

    it "elapsed time between two answers by the same user should be greater than 20 secs" do
      answer = Answer.make_unsaved(:question_id => @answer.question_id,
                                   :created_at => @answer.created_at+1,
                                   :user_id => @answer.user_id,
                                   :group_id => @answer.group_id,
                                   :votes => {})
      answer.valid?.should be_false
    end
  end

  describe "association" do
  end

  describe "callbacks" do
    describe "Answer#unsolve_question" do
      it "should set the answer's question as unsolved when the question is deleted" do
        question = @answer.question
        question.answer = @answer
        question.accepted = true
        question.save
        question.reload

        question.accepted.should be_true
        question.answer.should_not be_nil

        @answer.destroy

        question.reload
        question.accepted.should be_false
        question.answer.should be_nil
      end
    end
  end

  describe "named scopes" do
  end

  describe "class methods" do
    describe "Answer#minimal" do
      it "should return a answer context without some keys" do
        Answer.should_receive(:without).with(:_keywords,
                                             :flags,
                                             :votes,
                                             :versions)
        Answer.minimal
      end
    end

    describe "Answer#ban" do
      it "should ban the answer" do
        @answer.banned.should be_false
        Answer.ban([@answer.id])
        @answer.reload
        @answer.banned.should be_true
      end
    end

    describe "Answer#unban" do
      it "should unban the answer" do
        @answer.ban
        @answer.reload
        Answer.unban([@answer.id])
        @answer.reload
        @answer.banned.should be_false
      end
    end
  end

  describe "instance methods" do
    describe "Answer#ban" do
    end

    describe "Answer#can_be_deleted_by?" do
    end

    describe "Answer#on_add_vote" do
    end

    describe "Answer#on_remove_vote" do
    end

    describe "Answer#flagged!" do
    end

    describe "Answer#to_html" do
    end

    describe "Answer#disable_limits?" do
    end

    describe "Answer#add_favorite!" do
    end

    describe "Answer#remove_favorite!" do
    end

    describe "Answer#favorite_for?" do
    end
  end
end
