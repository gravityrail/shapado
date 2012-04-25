class InvoicesController < ApplicationController
  include ActionView::Helpers::DateHelper
  layout "manage"
  tabs :default => :invoices
  before_filter :authenticate_user!, :except => [:webhook]
  before_filter :owner_required, :except => [:webhook]
  before_filter :check_new_invoice, :only => ['index']
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

  def upcoming
    if current_group.is_stripe_customer?
      @upcoming_invoice = current_group.upcoming_invoice
    end

  end

  def auto_update
    version = ShapadoVersion.where(:token => params[:plan]).first
    current_group.upgrade!(current_user, version)
    redirect_to invoices_path, :notice => "Your plan has been upgraded to #{current_group.reload.shapado_version.token}, you will be charged on your upcoming invoice due in #{distance_of_time_in_words_to_now(current_group.next_recurring_charge)}."
  end

  def create
    Stripe.api_key = PaymentsConfig['secret']
    stripe_token = params[:stripeToken]
    token = params[:token]

    current_group.charge!(token,stripe_token)
    redirect_to invoices_path
  end

  def update
    Stripe.api_key = PaymentsConfig['secret']
    stripe_token = params[:stripeToken]
    token = params[:plan]
    current_user.charge!(token,stripe_token)
    redirect_to invoices_path
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
  protected
  def check_new_invoice
    return unless current_group.is_stripe_customer?
    if (current_group.next_recurring_charge &&
        current_group.next_recurring_charge <= Time.now) ||
        current_group.invoices.count == 0
      Stripe.api_key = PaymentsConfig['secret']
      current_group.create_invoices
    end
  end

  def save_and_charge
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
end
