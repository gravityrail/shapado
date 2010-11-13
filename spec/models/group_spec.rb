require 'spec_helper'

describe Group do
  before(:each) do
    @group = Fabricate(:group)
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
    describe "Group#humanize_reputation_constrain" do
    end

    describe "Group#humanize_reputation_rewards" do
    end

    describe "Group#find_field_from_params" do
    end
  end

  describe "instance methods" do
    describe "Group#has_custom_domain?" do
      it "should return false for a group with a localhost.lan domain" do
        @group.domain = "ask.test.loc"
        @group.has_custom_domain?.should be_false
      end

      it "should return true for a group with a mycustom.com" do
        @group.domain = "mycustom.com"
        @group.has_custom_domain?.should be_true
      end
    end

    describe "Group#tag_list" do
      it "should fetch the group's tag_list" do
        pending
      end
    end

    describe "Group#default_tags=" do
      it "should convert the string separted by comas in an array" do
        @group.default_tags = "apples,oranges"
        @group.default_tags.should == %w[apples oranges]
      end

      it "should convert the string separted by comas and spaces in an array" do
        @group.default_tags = "apples,oranges mango"
        @group.default_tags.should == %w[apples oranges mango]
      end
    end

    describe "Group#add_member" do
      before(:each) do
        @user = Fabricate(:user)
      end

      after(:each) do
        @user.destroy
      end

      it "should add the @user as group member" do
        @group.is_member?(@user).should be_false
        @group.add_member(@user, "user")
        @group.is_member?(@user).should be_true
      end
    end

    describe "Group#is_member?" do
      before(:each) do
        @user = Fabricate(:user)
      end

      after(:each) do
        @user.destroy
      end

      it "should return false for @user" do
        @group.is_member?(@user).should be_false
      end
    end

    describe "Group#users" do
      before(:each) do
        @user = Fabricate(:user)
      end

      after(:each) do
        @user.destroy
      end

      it "should return and empty array" do
        @group.users.all.to_a.should be_empty
      end
    end

    describe "Group#pending?" do
    end

    describe "Group#on_activity" do
    end

    describe "Group#language=" do
    end
  end
end
