class InvoicesController < ApplicationController
  layout "manage"
  tabs :default => :invoices
  before_filter :authenticate_user!, :except => [:webhook]
  before_filter :owner_required, :except => [:webhook]
  skip_before_filter :find_group, :only => [:webhook]


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

  def webhook
    if params[:type] == 'invoice.created'
      @invoice = Invoice.where(:stripe_customer => params[:data][:object][:customer]).first

      if @invoice && @invoice.group.shapado_version && @invoice.group.shapado_version.token == 'private'
        Stripe.api_key = PaymentsConfig['secret']
        Stripe::InvoiceItem.create(
          :customer => @invoice.stripe_customer,
          :amount => @invoice.group.memberships.count*@invoice.group.shapado_version.per_user,
          :currency => "usd",
          :description => "fee for #{@invoice.group.memberships.count} users"
        )

      end
    end
  end
end
