require 'spec_helper'

describe Question do
  before(:each) do
    @question = Fabricate(:question)
  end

  describe "module/plugin inclusions (optional)" do
  end

  describe "validations" do
    it "should have a title" do
      @question.title = ""
      @question.valid?.should be_false
    end

    it "should have a creator(user)" do
      @question.user = nil
      @question.valid?.should be_false
    end

    it "question slug should unique" do
      question = Fabricate.build(:question,
                           :slug => @question.slug,
                           :group => @question.group)
      question.slug = @question.slug
      question.group = @question.group
      question.valid?.should be_false
    end
  end

  describe "association" do
  end

  describe "callbacks" do
  end

  describe "named scopes" do
  end

  describe "class methods" do
    describe "Question#related_questions" do
      it "should get the related questions with for a question with tag generate" do
        Question.related_questions(Fabricate(:question, :tags => ["generate"]))
      end
    end

    describe "Question#ban" do
      it "should ban the question" do
        @question.banned.should be_false
        Question.ban([@question.id])
        @question.reload
        @question.banned.should be_true
      end
    end

    describe "Question#ban" do
      it "should unban the question" do
        @question.ban
        @question.reload
        Question.unban([@question.id])
        @question.reload
        @question.banned.should be_true
      end
    end
  end

  describe "instance methods" do
    describe "Question#first_tags" do
      it "should get the first_tags(6)" do
        @question.tags = %w[a b c d e f g]
        @question.first_tags.should == %w[a b c d e f]
        @question.first_tags.size == 6
      end
    end

    describe "Question#tags=" do
      it "should convert the string separted by comas in an array" do
        @question.tags = "apples,oranges"
        @question.tags.should == %w[apples oranges]
      end

      it "should convert the string separted by comas and spaces in an array" do
        @question.tags = "apples,oranges mango"
        @question.tags.should == %w[apples oranges mango]
      end
    end

    describe "Question#viewed!" do
      it "should increment the question's view count" do
        @question.views_count.should == 0
        @question.viewed!("127.0.0.0")
        @question.views_count.should == 1
      end

      it "should not increment the question's view count" do
        @question.viewed!("127.0.0.0")
        @question.views_count.should == 1
        @question.viewed!("127.0.0.0")
        @question.views_count.should == 1
      end
    end

    describe "Question#answer_added!" do
      it "should increment the question's answer counter" do
        @question.should_receive(:on_activity)
        @question.answers_count.should == 0
        @question.answer_added!
        @question.answers_count.should == 1
      end
    end

    describe "Question#answer_removed!" do
      it "should decrement the question's answer counter" do
        @question.should_receive(:on_activity)
        @question.answer_added!
        @question.answers_count.should == 1
        @question.answer_removed!
        @question.reload
        @question.answers_count.should == 0
      end
    end

    describe "Question#flagged!" do
      it "should increment the question's flags counter" do
        @question.flags_count.should == 0
        @question.flagged!
        @question.flags_count.should == 1
      end
    end

    describe "Question#on_add_vote" do
      before(:each) do
        @question.stub!(:on_activity)
        @voter = Fabricate.build(:user)
        @voter.stub!(:on_activity)
        @question.user.stub!(:update_reputation)
      end

      describe "should update question's user reputation with" do
        it "question_receives_up_vote" do
          @question.user.should_receive(:update_reputation).
                            with(:question_receives_up_vote, anything)
          @question.on_add_vote(1, @voter)
        end

        it "question_receives_down_vote" do
          @question.user.should_receive(:update_reputation).
                            with(:question_receives_down_vote, anything)
          @question.on_add_vote(-1, @voter)
        end
      end

      describe "should report activity by voter for" do
        it "vote_up_question" do
          @voter.should_receive(:on_activity).with(:vote_up_question, anything)
          @question.on_add_vote(1, @voter)
        end

        it "vote_down_question" do
          @voter.should_receive(:on_activity).with(:vote_down_question, anything)
          @question.on_add_vote(-1, @voter)
        end
      end
    end

    describe "Question#on_remove_vote" do
      before(:each) do
        @question.stub!(:on_activity)
        @voter = Fabricate.build(:user)
        @voter.stub!(:on_activity)
        @question.user.stub!(:update_reputation)
      end

      describe "should update question's user reputation with" do
        it "question_undo_up_vote" do
          @question.user.should_receive(:update_reputation).
                            with(:question_undo_up_vote, anything)
          @question.on_remove_vote(1, @voter)
        end

        it "question_undo_down_vote" do
          @question.user.should_receive(:update_reputation).
                            with(:question_undo_down_vote, anything)
          @question.on_remove_vote(-1, @voter)
        end
      end

      describe "should report activity by voter for" do
        it "undo_vote_up_question" do
          @voter.should_receive(:on_activity).with(:undo_vote_up_question, anything)
          @question.on_remove_vote(1, @voter)
        end

        it "undo_vote_down_question" do
          @voter.should_receive(:on_activity).with(:undo_vote_down_question, anything)
          @question.on_remove_vote(-1, @voter)
        end
      end
    end

    describe "Question#add_favorite!" do
      before(:each) do
        @question.stub!(:on_activity)
        @user = Fabricate.build(:user)
        @fav = Favorite.new
      end

      it "should increment the question's favorite counter" do
        @question.favorites_count.should == 0
        @question.add_favorite!(@fav, @user)
        @question.favorites_count.should == 1
      end
    end

    describe "Question#remove_favorite!" do
      before(:each) do
        @question.stub!(:on_activity)
        @user = Fabricate.build(:user)
      end

      it "should decrement the question's favorite counter" do
        @question.add_favorite!(Favorite.new, @user)
        @question.favorites_count.should == 1
        @question.remove_favorite!(Favorite.new, @user)
        @question.reload
        @question.favorites_count.should == 0
      end
    end

    describe "Question#on_activity" do
      it "should increment the question hotness" do
        @question.hotness.should == 0
        @question.on_activity
        @question.hotness.should == 1
      end

      it "should not call update_activity_at" do
        @question.should_not_receive(:update_activity_at)
        @question.on_activity(false)
      end
    end

    describe "Question#update_activity_at" do
      before(:each) do
        @current_time = Time.now
        Time.stub!(:now).and_return(@current_time)
        @question.override(:activity_at => Time.now.yesterday)
        @question.reload
      end

      it "should override the last activity date to the current time" do
        @question.activity_at.strftime("%D %T").should_not == @current_time.strftime("%D %T")
        @question.update_activity_at
        @question.reload
        @question.activity_at.strftime("%D %T").should == @current_time.strftime("%D %T")
      end

      it "should set the last activity date to the current time" do
        @question.stub(:new_record?).and_return(true)
        @question.activity_at.strftime("%D %T").should_not == @current_time.strftime("%D %T")
        @question.update_activity_at
        @question.activity_at.strftime("%D %T").should == @current_time.strftime("%D %T")
      end
    end

    describe "Question#ban" do
      it "should ban the question" do
        @question.banned.should be_false
        @question.ban
        @question.reload
        @question.banned.should be_true
      end
    end

    describe "Question#unban" do
      it "should unban the question" do
        @question.ban
        @question.unban
        @question.reload
        @question.banned.should be_false
      end
    end

    describe "Question#favorite_for?(user)" do
      it "should nil for question creator" do
        @question.favorite_for?(@question.user).should be_nil
      end

      it "should return favorite's user" do
        @favorite = Fabricate(:favorite, :group => @question.group,
                                         :question => @question)
        @question.favorite_for?(@favorite.user).id.should == @favorite.user.id
      end
    end

    describe "Question#add_follower" do
      before(:each) do
        @follower = Fabricate(:user)
        @question.stub(:follower?).and_return(false)
      end

      after(:each) do
        @follower.destroy
      end

      it "should add @follower as question's follower" do
        @question.add_follower(@follower)
        @question.reload
        @question.followers_count.should == 1
        @question.watchers.should include @follower.id
      end

      it "should not @follower as question's follower" do
        @question.should_receive(:follower?).and_return(true)
        @question.add_follower(@follower)
        @question.reload
        @question.followers_count.should == 0
        @question.watchers.should_not include @follower.id
      end
    end


    describe "Question#remove_follower" do
      before(:each) do
        @follower = Fabricate(:user)
        @question.add_follower(@follower)
        @question.reload
        @question.stub(:follower?).and_return(true)
      end

      it "follower add @follower as question's follower" do
        @question.remove_follower(@follower)
        @question.reload
        @question.followers_count.should == 0
        @question.watchers.should_not include @follower.id
      end
    end

    describe "Question#follower?" do
      before(:each) do
        @follower = Fabricate(:user)
        @question.stub(:follower?).and_return(true)
        @question.add_follower(@follower)
        @question.reload
      end

      after(:each) do
        @follower.destroy
      end

      it "should return true for @follower" do
        @question.follower?(@follower).should be_true
      end

      it "should return false for question's user" do
        @question.follower?(@question.user).should be_false
      end
    end

    describe "Question#disable_limits?" do
    end

    describe "Question#check_useful" do
    end

    describe "Question#disallow_spam" do
    end

    describe "Question#answered" do
    end

    describe "Question#update_last_target" do
    end

    describe "Question#can_be_requested_to_close_by?" do
    end

    describe "Question#can_be_requested_to_open_by?" do
    end

    describe "Question#can_be_deleted_by?" do
    end

    describe "Question#close_reason" do
    end

    describe "Question#last_target=" do
    end
  end
end
