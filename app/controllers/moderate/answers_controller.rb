class Moderate::AnswersController < ApplicationController
  before_filter :login_required, :except => [:show, :create]

  def index
  end

  protected
end
