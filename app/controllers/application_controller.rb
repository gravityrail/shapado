# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Rack::Recaptcha::Helpers
  include Subdomains
  include Sweepers

  include Shapado::Controllers::Access
  include Shapado::Controllers::Routes
  include Shapado::Controllers::Locale
  include Shapado::Controllers::Utils

  if !AppConfig.recaptcha['activate']
    def recaptcha_valid?
      true
    end
  end

  protect_from_forgery

  before_filter :find_group
  before_filter :check_group_access
  before_filter :set_locale
  before_filter :find_languages
  layout :set_layout

  helper_method :recaptcha_tag

  rescue_from Error404, :with => :render_404
  rescue_from Mongoid::Errors::DocumentNotFound, :with => :render_404

  protected
  def find_group
    @current_group ||= begin
      subdomains = request.subdomains
      subdomains.delete("www") if request.host == "www.#{AppConfig.domain}"
      _current_group = Group.where(:conditions => {:state => "active", :domain => request.host}).first
      unless _current_group
        if subdomain = subdomains.first
          _current_group = Group.where(:state => "active", :subdomain => subdomain).first
          unless _current_group.nil?
            redirect_to domain_url(:custom => _current_group.domain)
            return
          end
        end
        flash[:warn] = t("global.group_not_found", :url => request.host)
        redirect_to domain_url(:custom => AppConfig.domain)
        return
      end
      _current_group
    end
    @current_group
  end

  def current_group
    @current_group
  end
  helper_method :current_group

  def scoped_conditions(conditions = {})
    unless current_tags.empty?
      conditions.deep_merge!({:tags => {:$all => current_tags}})
    end
    conditions.deep_merge!({:group_id => current_group.id})
    conditions.deep_merge!(language_conditions)
    conditions
  end
  helper_method :scoped_conditions

  def set_layout
    devise_controller? || (action_name == "new" && controller_name == "users") ? 'sessions' : 'application'
  end

  def render_404
    Rails.logger.info "ROUTE NOT FOUND (404): #{request.url}"

    respond_to do |format|
      format.html { render "public_errors/not_found", :status => '404 Not Found' }
      format.json { render :json => {:success => false, :message => "Not Found"}, :status => '404 Not Found' }
    end
  end
end
