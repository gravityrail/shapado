class Moderate::QuestionsController < ApplicationController
  before_filter :login_required
  before_filter :moderator_required

  tabs :default => :questions
  subtabs :index => [[:newest, "created_at desc"],
                     [:hot, "hotness desc, views_count desc"],
                     [:votes, "votes_average desc"],
                     [:activity, "activity_at desc"],
                     [:expert, "created_at desc"]]

  def index
    options = {:banned => false,
               :group_id => current_group.id,
               :per_page => params[:per_page] || 25,
               :page => params[:questions_page] || 1}

    @questions = Question.paginate(options.merge(:tags => {:$size => 0}))
  end

  protected
end
