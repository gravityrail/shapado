class Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :payed, :type => Boolean, :default => false
  field :payed_at, :type => Time

  field :action, :type => String

  field :items, :type => Array, :default => []
  field :total, :type => Float, :default => 0.0

  field :version, :type => String

  referenced_in :credit_card
  referenced_in :campaign
  referenced_in :account

  validates_presence_of :action, :account
  validates_inclusion_of :action, :in => %w[upgrade_account publish_campaign]

  attr_protected :payed, :total, :items

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
end
