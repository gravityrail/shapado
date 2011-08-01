class Invoice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :payed, :type => Boolean, :default => false
  field :payed_at, :type => Time

  field :action, :type => String
  field :version, :type => String

  field :items, :type => Array, :default => []
  field :total, :type => Float, :default => 0.0

  field :order_number, :type => String

  field :first_name, :type => String
  field :last_name, :type => String
  field :email, :type => String
  field :payment_method, :type => String
  field :cc_type, :type => String
  field :cc_ending, :type => String
  field :billing_address1, :type => String
  field :billing_address2, :type => String
  field :country, :type => String

  referenced_in :credit_card
  referenced_in :group

  validates_presence_of :action, :group
  validates_inclusion_of :action, :in => %w[upgrade_plan]

  attr_protected :payed, :total, :items

  before_create :generate_order_number

  def reset!
    self.items = []
    self.total = 0.0
  end

  def add_item(name, description, value, doc)
    self.items << {
      "name" => name,
      "description" => description,
      "value" => value,
      "item_class" => doc.class.to_s,
      "item_id" => doc.id
    }
    self.total += value
  end

  def charge!(ip, cc = nil)
    cc = self.credit_card if cc.nil?

    raise ArgumentError, "credit card is invalid" if cc.nil? || !cc.valid?
    gateway = ActiveMerchant::Billing::PaypalGateway.new(
      :login    => PaymentsConfig["login"],
      :password => PaymentsConfig["password"],
      :signature => PaymentsConfig["signature"]
    )

    Rails.logger.info ">> Charging #{self.total} to #{self.group_id} #{cc.inspect}"
    response = gateway.authorize(self.total, cc.to_am, :ip => ip)

    if response.success?
      gateway.capture(self.total, response.authorization)
      self.payed = true
      self.payed_at = Time.now.utc
      return self.save(:validate => false, :safe => true)
    else
      Rails.logger.info ">> Cannot charge #{cc.inspect}: #{response.message}"
      return false
    end

  end

  def total_in_dollars
    self.total / 100.0
  end

  def copy_info_from_cc(cc)
    self[:first_name] = cc.first_name
    self[:last_name]  = cc.last_name
    self[:email] = cc.email
    self[:payment_method] = "credit_card"
    self[:cc_type] = cc.credit_card_type
    self[:cc_ending] = cc.ending_in
    self[:billing_address1] = cc.address1
    self[:billing_address2] = cc.address2
    self[:country] = cc.country
  end

  protected
  def generate_order_number
    self[:order_number] = (self.group.invoices.count+1).to_s.rjust(8, "0")
  end
end
