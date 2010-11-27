class MobileController < ApplicationController
  layout 'mobile'

  def index
    @questions = current_group.questions.order_by(:created_at.desc).paginate(:per_page => params[:per_page]||25, :page => params[:page])
  end

end
