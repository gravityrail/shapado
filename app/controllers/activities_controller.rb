class ActivitiesController < ApplicationController
  tabs :default => :activities
  def index
    conds = {}
    if params[:context] == "by_me" && logged_in?
      conds[:user_id] = current_user.id
    end

    case params[:tab]
    when "questions"
      conds[:trackable_type] = "Question"
    when "answers"
      conds[:trackable_type] = "Answer"
    when "users"
      conds[:trackable_type] = "User"
    when "pages"
      conds[:trackable_type] = "Page"
    end

    @activities = current_group.activities.where(conds).order(:created_at.desc).
                                           page(params[:page].to_i)

    respond_to do |format|
      format.html
      format.json { render :json => @activities }
    end
  end

end
