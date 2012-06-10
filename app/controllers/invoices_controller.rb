class InvoicesController < ApplicationController
  include ActionView::Helpers::DateHelper
  layout "manage"
  tabs :default => :invoices
  before_filter :authenticate_user!, :except => [:create, :webhook]
  before_filter :owner_required, :except => [:create, :webhook]
  before_filter :check_new_invoice, :only => ['index']
  skip_before_filter :find_group, :only => [:webhook]


  def index
    if current_group.shapado_version.token != 'free' &&
      current_group.upcoming_invoice.nil?
      current_group.set_incoming_invoice
    end
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
      @invoice = current_group.upcoming_invoice
    end
  end

  def create
    p params.inspect
    if !current_user
      @user = User.new
      @user.login = params[:login]
      @user.name = params[:name]
      @user.email = params[:email]
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      return if !@user.save
      sign_in @user
    end
    user = @user || current_user
    if user && !user.owner_of?(current_group)
      @group = Group.new(:language => 'en',
        :subdomain => params[:subdomain],
        :name => params[:group_name],
      )

      @group.owner = user
      @group.state = "active"

      if @group.save
        @group.create_default_widgets
        Jobs::Images.async.generate_group_thumbnails(@group.id)
        @group.add_member(user, "owner")
      end
    end
    group = @group || current_group
    return unless current_user.owner_of?(group)
    Stripe.api_key = PaymentsConfig['secret']
    stripe_token = params[:stripeToken]
    token = params[:token]
    group.charge!(token,stripe_token)
    redirect_to("#{request.protocol}#{group.domain}:#{request.port}#{invoices_path}")
  end

  def success
    @invoice = current_group.invoices.find(params[:id])
  end

  def webhook
    group = group = Group.where(:stripe_customer_id => params[:data][:object][:customer]).first
    if params[:type] == 'customer.subscription.updated'
      group = Group.where(:stripe_customer_id => params[:data][:object][:customer]).first
      if group && group.shapado_version && group.shapado_version.token == 'private'
        Stripe.api_key = PaymentsConfig['secret']
        Stripe::InvoiceItem.create(
          :customer => group.stripe_customer_id,
          :amount => group.memberships.count*group.shapado_version.per_user,
          :currency => "usd",
          :description => I18n.t("invoices.webhook.has_users_fees",
                                 :count => group.memberships.count)
        )

      end
    elsif ['invoice.created','invoiceitem.created'].include?(params[:type]) &&
        group.shapado_version.token == 'private'
      group.set_incoming_invoice
    end

    respond_to do |format|
      format.xml {  head :no_content }
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
end
