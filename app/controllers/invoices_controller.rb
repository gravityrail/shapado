class InvoicesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :owner_required

  filter_parameter_logging :number, :verification_code

  def index
    @invoices = current_group.invoices.where(:payed => true).paginate(:per_page => 25, :page => params[:page])
  end

  def show
    @invoice = current_group.invoices.find(params[:id])

    ropts = {}
    ropts[:layout] = false if params[:print] == '1'

    render ropts
  end

  def update
    @invoice = current_group.invoices.find(params[:id])

    @cc = current_group.credit_card
    cc_params = params[:credit_card] || {}

    if @cc.nil? || !@cc.remember
      @cc = CreditCard.new(cc_params)
    end

    @invoice.safe_update(%w[version], params[:invoice]||{})
    @invoice.credit_card = @cc

    if @cc.remember || cc_params["remember"] == "1"
      @cc.group = current_group
      @cc.save
    end

    if @cc.valid? && @invoice.save
      process_payment_and_redirect(@invoice.charge!(request.remote_ip, @cc), @invoice)
    else
      flash[:error] = I18n.t("invoices.flash.cannot_pay")
      render 'edit'
    end
  end
end
