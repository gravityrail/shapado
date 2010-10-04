class Moderate::QuestionsController < ApplicationController
  before_filter :login_required
  before_filter :moderator_required

  tabs :default => :questions
  subtabs :index => [[:retag, "created_at desc"]],
          :flagged => [[:flagged, "created_at desc"]]


  def index
    @active_subtab = "retagg"
    options = {:banned => false,
               :group_id => current_group.id,
               :per_page => params[:per_page] || 25,
               :page => params[:questions_page] || 1}

    @questions = Question.paginate(options.merge(:tags => {:$size => 0}))
  end

  def flagged
    options = {:group_id => current_group.id,
               :per_page => params[:per_page] || 25,
               :page => params[:questions_page] || 1}
    options[:banned] = false

    if params[:filter] == "banned"
       options[:banned] = true
    end
    @questions = current_group.questions.paginate(options.merge(:order => "flags_count desc", :flags_count.gt => 0))
  end

  def to_close
    options = {:group_id => current_group.id,
               :per_page => params[:per_page] || 25,
               :page => params[:questions_page] || 1,
               :closed => true}

    @questions = current_group.questions.paginate(options.merge(:order => "close_requests_count desc", :close_requests_count.gt => 0))
  end

  def manage
    case params[:commit]
    when "ban"
      Question.ban(params[:question_ids] || [], {:group_id => current_group.id})
    when "unban"
      Question.unban(params[:question_ids] || [], {:group_id => current_group.id})
    when "delete"
      Question.delete_all({:_id.in =>  params[:question_ids], :group_id => current_group.id})
    end

    respond_to do |format|
      format.html{redirect_to :action => "flagged"}
    end
  end

  protected
  def current_scope
  end
end
