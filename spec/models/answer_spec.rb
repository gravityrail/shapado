require 'spec_helper'

describe Answer do
  before(:each) do
    @answer = Answer.make(:votes => {})
  end

  describe "module/plugin inclusions (optional)" do
  end

  describe "validations" do
    it "the answer of a user in a question should be unique" do
    end

    it "elapsed time between two answers by the same user should be greater than 20 secs" do
    end
  end

  describe "association" do
  end

  describe "callbacks" do
    describe "Answer#unsolve_question" do
      it "should set the answer's question as unsolved when the question is deleted" do
      end
    end
  end

  describe "named scopes" do
  end

  describe "class methods" do
    describe "Answer#minimal" do
    end
    describe "Answer#ban" do
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
