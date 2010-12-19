require 'spec_helper'

describe User do
  before(:each) do
    @user = Fabricate(:user)
  end

  describe "module/plugin inclusions (optional)" do
  end

  describe "validations" do
  end

  describe "association" do
  end

  describe "callbacks" do
  end

  describe "named scopes" do
  end

  describe "class methods" do
    describe "User#find_for_authentication" do
      it "should get the user with his login" do
        User.find_for_authentication(:email => @user.login).should == @user
      end
    end

    describe "User#find_by_login_or_id" do

      it "should return the user with his login" do
        User.find_by_login_or_id(@user.login).should == @user
      end

      it "should return the user with his id" do
        User.find_by_login_or_id(@user.login).should == @user
      end
    end

    describe "User#find_experts" do
      it("should return @user") do
        @user.preferred_languages = ["en", "es", "fr"]
        @user.save
        @stat =Fabricate(:user_stat, :user => @user, :answer_tags => ["tag1"] )
        User.find_experts(["tag1"]).first.should == @user
      end

      it("should not return @user") do
        @user.preferred_languages = ["en", "es", "fr"]
        @user.save
        @stat =Fabricate(:user_stat, :user => @user, :answer_tags => ["tag1"] )
        User.find_experts(["tag1"], ["en"], {:except => @user.id}).first.should_not == @user
      end
    end
  end

  describe "instance methods" do
    describe "User#membership_list" do
      it "should" do
        @user.membership_list
      end
    end

    describe "User#login=" do
      it "should downcase the login" do
        @user.login = "MEE"
        @user.login.should == "mee"
      end
    end

    describe "User#email=" do
      it "should downcase the email" do
        @user.email = "ME@example.com"
        @user.email.should == "me@example.com"
      end
    end

    describe "User#to_param" do
      it "should return the user id when the login is blank" do
        @user.login = ""
        @user.to_param.should == @user.id
      end

      it "should return the user id when the login have special charts" do
        @user.login = "jhon@doe"
        @user.to_param.should == @user.id
      end

      it "should return the user login if this have wight spaces" do
        @user.login = "jhon doe"
        @user.to_param.should == @user.login
      end
    end

    describe "User#add_preferred_tags" do
      it "should add unique tags" do
        @group = Fabricate(:group, :owner => @user)
        @user.add_preferred_tags(["a", "a", "b", "c"], @group)
        @user = User.find(@user.id)
        @user.config_for(@group).preferred_tags.should == ["a", "b", "c"]
        @group.destroy
      end
    end

    describe "User#remove_preferred_tags" do
    end

    describe "User#preferred_tags_on" do
    end

    describe "User#update_language_filter" do
    end

    describe "User#languages_to_filter" do
    end

    describe "User#is_preferred_tag?" do
    end

    describe "User#admin?" do
    end

    describe "User#age" do
    end

    describe "User#can_modify?" do
    end

    describe "User#groups" do
    end

    describe "User#member_of?" do
    end

    describe "User#role_on" do
    end

    describe "User#owner_of?" do
    end

    describe "User#mod_of?" do
    end

    describe "User#editor_of?" do
    end

    describe "User#user_of?" do
    end

    describe "User#main_language" do
    end

    describe "User#openid_login?" do
    end

    describe "User#twitter_login?" do
    end

    describe "User#has_voted?" do
    end

    describe "User#vote_on" do
    end

    describe "User#favorite?" do
    end

    describe "User#favorite" do
    end

    describe "User#logged!" do
    end

    describe "User#on_activity" do
    end

    describe "User#activity_on" do
    end

    describe "User#reset_activity_days!" do
    end

    describe "User#upvote!" do
    end

    describe "User#downvote!" do
    end

    describe "User#update_reputation" do
    end

    describe "User#reputation_on" do
    end

    describe "User#stats" do
    end

    describe "User#badges_count_on" do
    end

    describe "User#badges_on" do
    end

    describe "User#find_badge_on" do
    end

    describe "User#add_friend" do
    end

    describe "User#remove_friend" do
    end

    describe "User#followers" do
    end

    describe "User#following" do
    end

    describe "User#following?" do
    end

    describe "User#viewed_on!" do
    end

    describe "User#config_for" do
    end

    describe "User#reputation_stats" do
    end

    describe "User#has_flagged?" do
    end

    describe "User#has_requested_to_close?" do
    end

    describe "User#has_requested_to_open?" do
    end

    describe "User#generate_uuid" do
    end
  end
end
