class ThemesController < ApplicationController
  layout "manage"
  before_filter :login_required, :except => [:index, :show]

  # GET /themes
  # GET /themes.json
  def index
    @themes = current_group.themes

    respond_to do |format|
      format.html # index.html.haml
      format.json  { render :json => @themes }
    end
  end

  # GET /themes/1
  # GET /themes/1.json
  def show
    @theme = Theme.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json  { render :json => @theme }
    end
  end

  # GET /themes/new
  # GET /themes/new.json
  def new
    @theme = Theme.new

    respond_to do |format|
      format.html # new.html.haml
      format.json  { render :json => @theme }
    end
  end

  # GET /themes/1/edit
  def edit
    conditions = {}
    if params[:tab] == "community"
      conditions[:community] = true
    else
      conditions[:group_id] = current_group.id
    end

    @theme = Theme.where(conditions).find(params[:id])
  end

  # POST /themes
  # POST /themes.json
  def create
    @theme = Theme.new(params[:theme])
    @theme.group = current_group
    @theme.ready = false
    @theme.set_has_js(params[:theme][:javascript])

    respond_to do |format|
      if @theme.save
        Jobs::Themes.async.generate_stylesheet(@theme.id).commit!(4)
        format.html { redirect_to(@theme, :notice => 'Theme was successfully created.') }
        format.json { render :json => @theme, :status => :created, :location => @theme }
      else
        format.html { render :action => "new" }
        format.json { render :json => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /themes/1
  # PUT /themes/1.json
  def update
    @theme = Theme.find(params[:id])
    @theme.ready = false
    @theme.set_has_js(params[:theme][:javascript])

    respond_to do |format|
      if @theme.update_attributes(params[:theme])
        Jobs::Themes.async.generate_stylesheet(@theme.id).commit!(4)
        format.html { redirect_to(@theme, :notice => 'Theme was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /themes/1
  # DELETE /themes/1.json
  def destroy
    @theme = current_group.themes.find(params[:id])
    @theme.destroy

    respond_to do |format|
      format.html { redirect_to(themes_url) }
      format.json  { head :ok }
    end
  end

  def remove_bg_image
    @theme = Theme.find(params[:id])
    @theme.delete_file("bg_image")
    @theme.save
    respond_to do |format|
      format.html { redirect_to edit_theme_path(@theme) }
      format.json { render :json => {:ok => true} }
    end
  end

  def apply
    @theme = Theme.find(params[:id])
    current_group.override(:current_theme_id => @theme.id)
    redirect_to theme_url(@theme)
  end
end
