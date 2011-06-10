class FacebookController < ApplicationController
  layout "facebook"

  def index
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
