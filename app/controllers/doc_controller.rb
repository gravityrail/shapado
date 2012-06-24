class DocController < ApplicationController
  layout 'doc'
  before_filter :check_ssl, :only => ['plans']
  def privacy
    set_page_title("Privacy")
  end
  def tos
    set_page_title("Terms of service")
  end

  def plans
    set_page_title(t('doc.plans.title'))
    render :layout => 'plans'
  end

  def chat
    set_page_title(t('doc.chat.title'))
  end

  protected

  def check_ssl
    if request.protocol == 'http://'
      redirect_to "https://#{AppConfig.domain}/plans"
    end
  end

end
