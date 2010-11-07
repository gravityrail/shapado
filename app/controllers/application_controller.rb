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

  protected
  def find_group
    @current_group ||= begin
      subdomains = request.subdomains
      subdomains.delete("www") if request.host == "www.#{AppConfig.domain}"
      _current_group = Group.first(:conditions => {:state => "active", :domain => request.host})
      unless _current_group
        if subdomain = subdomains.first
          _current_group = Group.first(:state => "active", :subdomain => subdomain)
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
  end
  helper_method :scoped_conditions

  def set_layout
    devise_controller? || (action_name == "new" && controller_name == "users") ? 'sessions' : 'application'
  end
end
