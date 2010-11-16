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
    @tag_names = params[:id].split("+")
    @tags =  current_scope.where(:name.in => @tag_names)
    @questions = current_group.questions.where( :tags.in => @tag_names ).
                          paginate(:page => params[:page], :per_page => params[:per_page]||50)
  end

  def new
  end

  def edit
    @tag = current_scope.find(params[:id])
  end

  def create
  end

  def update
    @tag = current_scope.find(params[:id])
    redirect_to tag_url(@tag)
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
