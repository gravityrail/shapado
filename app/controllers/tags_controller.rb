class TagsController < ApplicationController

  def index
    @tags = current_scope.paginate(:page => params[:page],
                             :per_page => params[:per_page] || 52)

    respond_to do |format|
      format.html do
        set_page_title(t("layouts.application.tags"))
      end
      format.js do
        html = render_to_string(:partial => "tag_table", :locals => {:tag_table => @tags})
        render :json => {:html => html}
      end
      format.json  { render :json => @tags.to_json }
    end
  end

  def show
    @tag = current_scope.where(:name => params[:id]).first
    @questions = current_group.questions.where( :tags.in => [@tag.name] ).
                          paginate(:page => params[:page], :per_page => params[:per_page]||50)
  end

  def new
  end

  def create
  end

  def update
  end

  def destroy
  end

  protected
  def current_scope
    if(!params[:q].blank?)
      current_group.tags.where(:name => /^#{Regexp.escape(params[:q])}/)
    else
      current_group.tags
    end
  end

end
