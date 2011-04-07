class WidgetsController < ApplicationController
  before_filter :login_required, :except => :embedded
  before_filter :check_permissions, :except => :embedded
  layout "manage"
  tabs :default => :widgets

  subtabs :widgets => [[:mainlist, "mainlist"],
                       [:question, "question"],
                       [:external, "external"]]

  # GET /widgets
  # GET /widgets.json
  def index
    @active_subtab ||= "mainlist"

    @widget = Widget.new
    @widgets = @group.send(:"#{@active_subtab}_widgets")
  end

  # POST /widgets
  # POST /widgets.json
  def create
    if Widget.types(params[:tab]).include?(params[:widget][:_type])
      @widget = params[:widget][:_type].constantize.new
    end

    @group.send(:"#{params[:tab]}_widgets") << @widget

    respond_to do |format|
      if @widget.valid? && @group.save
        flash[:notice] = 'Widget was successfully created.'
        format.html { redirect_to widgets_path(:tab => params[:tab]) }
        format.json  { render :json => @widget.to_json, :status => :created, :location => widget_path(:id => @widget.id) }
      else
        format.html { render :action => "index" }
        format.json  { render :json => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /widgets
  # PUT /widgets.json
  def update
    @widget = @group.send(:"#{params[:tab]}_widgets").find(params[:id])
    @widget.update_settings(params)

    respond_to do |format|
      if @widget.valid? && @group.save && @widget.save
        flash[:notice] = 'Widget was successfully updated.'
        format.html { redirect_to widgets_path(:tab => params[:tab]) }
        format.json  { render :json => @widget.to_json, :status => :updated, :location => widget_path(:id => @widget.id) }
      else
        format.html { render :action => "index" }
        format.json  { render :json => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /ads/1
  # DELETE /ads/1.json
  def destroy
    @widget = @group.widgets.find(params[:id])
    @group.widgets.delete(@widget)
    @group.save

    respond_to do |format|
      format.html { redirect_to(widgets_url) }
      format.json  { head :ok }
    end
  end

  def move
    widgets = @group.send(:"#{params[:tab]}_widgets")
    widget = widgets.find(params[:id])
    widget.move_to(params[:move_to], widgets, params[:tab])
    redirect_to widgets_path(:tab => params[:tab])
  end

  def embedded
    @widget = current_group.external_widgets.
      detect {|f| f["_id"] == params[:id] }
    render :layout => false
  end

  private
  def check_permissions
    @group = current_group

    if @group.nil?
      redirect_to groups_path
    elsif !current_user.owner_of?(@group)
      flash[:error] = t("global.permission_denied")
      redirect_to ads_path
    end
  end
end
