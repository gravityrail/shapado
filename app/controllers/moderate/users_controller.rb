class Moderate::UsersController < ApplicationController
  before_filter :login_required, :except => [:show, :create]

  def index

  end

  protected
end
