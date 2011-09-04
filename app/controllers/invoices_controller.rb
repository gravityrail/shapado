class InvoicesController < ApplicationController
  layout "manage"
  tabs :default => :invoices
  before_filter :authenticate_user!
  before_filter :owner_required

  def index
    @invoices = current_group.invoices.where(:payed => true).page(params["page"])
  end

  def show
    @invoice = current_group.invoices.find(params[:id])

    ropts = {}
    ropts[:layout] = "printing" if params[:print] == '1'

    render ropts
  end

  def update
    @invoice = current_group.invoices.find(params[:id])

    @cc = current_group.credit_card

    cc_params = params[:credit_card] || {}
    if cc_params.empty?
      @cc = current_group.credit_card
    else
      @cc = CreditCard.new(cc_params)
    end

    @invoice.safe_update(%w[version], params[:invoice]||{})
    @invoice.credit_card = @cc

    if @cc.remember || cc_params["remember"] == "1"
      @cc.group = current_group
      @cc.save
    end

    @invoice.copy_info_from_cc(@cc)

    if @cc.valid? && @invoice.save
      if process_payment(@invoice.charge!(request.remote_ip, @cc), @invoice)
        redirect_to success_invoice_path(@invoice)
      else
        flash[:error] = I18n.t("invoices.flash.cannot_pay")
        render 'edit'
      end
    else
      flash[:error] = I18n.t("invoices.flash.cannot_pay")
      render 'edit'
    end
  end

  def success
    @invoice = current_group.invoices.find(params[:id])
  end
end
