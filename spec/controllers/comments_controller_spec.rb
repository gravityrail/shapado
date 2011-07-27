require 'spec_helper'

describe CommentsController do
  include Devise::TestHelpers

  before (:each) do
    @group = stub_group
    @user = User.make(:user)
    Thread.current[:current_user] = @user
    @question = Question.make(:question, :group => @group)
    stub_authentication @user
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', :question_id => @question.slug, :format => :json
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    before (:each) do
      @comment = Comment.make_unsaved(:comment,
                              :group_id => @group.id,
                              :user_id => @user.id)
      @question.comments << @comment
      @comment.save
      stub_group(@question.group)
    end

    it "should be successful" do
      get 'edit', :id => @comment.id, :question_id => @question.id, :format => "js"
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before (:each) do
      @comment = Comment.make(:comment,
                              :group_id => @group.id,
                              :user_id => @user.id)
      @question.comments << @comment
      @comment.save
      stub_group(@group)
    end

    it "should be successful" do
      post 'create', :question_id => @question.id, :comment => Comment.plan(:comment, :user => @user)
      response.should redirect_to question_path(:id => assigns[:question].slug)
    end
  end

  describe "PUT 'update'" do
    before (:each) do
      @comment = Comment.make(:comment,
                              :group_id => @group.id,
                              :user_id => @user.id)
      @question.comments << @comment
      @comment.save

      @comment_attrs = Comment.plan(:comment, :user => @user)
      stub_group(@question.group)
    end

    it "should be successful" do
      @user.stub!(:can_modify?).with(@comment).and_return(true)
      put 'update', :id => @comment.id, :question_id => @question.id, :comment => @comment_attrs
      response.should redirect_to question_path(:id => @question.slug)
    end
  end

  describe "DELETE 'destroy'" do
    before (:each) do
      @comment = Comment.make(:comment,
                              :group_id => @group.id,
                              :user_id => @user.id)
      @question.comments << @comment
      @comment.save
      stub_group(@question.group)
    end

    it "should be successful" do
      @user.should_receive(:mod_of?).with{@group}.and_return(true)
      delete 'destroy', :id => @comment.id, :question_id => @question.id
      response.should redirect_to question_path(:id => @question.slug)
    end
  end
end
