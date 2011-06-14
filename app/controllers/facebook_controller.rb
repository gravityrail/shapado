class FacebookController < ApplicationController
  layout "facebook"

  subtabs :index => [[:newest, [:created_at, Mongo::DESCENDING]],
                     [:hot, [[:hotness, Mongo::DESCENDING], [:views_count, Mongo::DESCENDING]]],
                     [:votes, [:votes_average, Mongo::DESCENDING]],
                     [:activity, [:activity_at, :desc]], [:expert, [:created_at, Mongo::DESCENDING]]],
          :unanswered => [[:newest, [:created_at, Mongo::DESCENDING]], [:votes, [:votes_average, Mongo::DESCENDING]], [:mytags, [:created_at, Mongo::DESCENDING]]],
          :show => [[:votes, [:votes_average, Mongo::DESCENDING]], [:oldest, [:created_at, Mongo::ASCENDING]], [:newest, [:created_at, Mongo::DESCENDING]]]

  def index
    find_questions
  end

  def enable_page
    @owner = User.where(:authentication_token => params[:t]).first

    if @owner.role_on(@current_group) != "owner"
      render :text => "you dont have permissions to do this!" and return
    end

    @current_group.override(:"share.fb_page_id" => params[:fb_page_id])

    redirect_to facebook_path(:signed_request => params[:signed_request])
  end

  protected
end
