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
    Stripe.api_key = PaymentsConfig['secret']
    token = params[:stripeToken]

    @invoice = current_group.invoices.find(params[:id])
    @invoice.stripe_token = params[:stripeToken]

    @invoice.safe_update(%w[version], params[:invoice]||{})

    if @invoice.save
      if @invoice.charge!
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
