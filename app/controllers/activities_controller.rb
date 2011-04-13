class ActivitiesController < ApplicationController
  def index
    conds = {}
    if params[:context] == "by_me" && logged_in?
      conds[:user_id] = current_user.id
    end

    @activities = current_group.activities.where(conds).order(:created_at.desc).
                  paginate(:page => params[:page], :per_page => params[:per_page]||25)

    respond_to do |format|
      format.html
      format.json { render :json => @activities }
    end
  end

end
